#!/usr/bin/env bash
# trace-flow.sh — show how a single SRv6 packet traverses the fabric, capturing
# at every hop so the uSID shift-and-forward is visible at each step.
#
# Usage:
#   ./trace-flow.sh [--install-route] <tenant> <src_id> <dst_id> [plane|all]
#
#     --install-route   if the host doesn't have an SRv6 route to dst, install
#                       it (forward + reverse, all 4 planes) before tracing.
#                       Spine pick: PAIRS table if matching, else dst % 8.
#                       Routes persist after the script exits.
#     tenant   = green | yellow
#     src_id   = 0..15 (host id, also leaf id)
#     dst_id   = 0..15
#     plane    = 0|1|2|3|all (default: all)
#
# Examples:
#   ./trace-flow.sh green  0 15                  # PAIRS pair, all 4 planes
#   ./trace-flow.sh yellow 3 12 2                # one plane only
#   ./trace-flow.sh --install-route yellow 0 12  # arbitrary pair; routes auto-installed
#
# For each plane the script captures on four points along the forward path:
#   (0) ingress leaf, host port (Ethernet32 green / Ethernet36 yellow)
#       — packet as the host emitted it (full SID list, no shifts yet)
#   (1) ingress leaf, uplink (Ethernet0)      — what the leaf forwards to spine
#   (2) spine, downlink toward dst leaf       — what the spine forwards on
#   (3) egress leaf, host port                — green: decapsulated;
#                                               yellow: still has host-DT SID stack
#
# Routes must already be installed (./test-routes.sh routes), unless
# --install-route is given.

set -uo pipefail

TOPO="${TOPO:-sonic-docker-4p-8x16}"
TCPDUMP_TIMEOUT="${TCPDUMP_TIMEOUT:-6}"
TCPDUMP_BIND_SLEEP="${TCPDUMP_BIND_SLEEP:-1.5}"
VERBOSE="${VERBOSE:-0}"

# Pair-to-spine map (must match test-routes.sh)
PAIRS=(
    "00:15:0"
    "01:14:2"
    "02:13:4"
    "03:12:6"
    "04:11:1"
    "05:10:3"
    "06:09:5"
    "07:08:7"
)

container() {
    local n="$1"
    if docker inspect "$n" &>/dev/null; then echo "$n"
    else echo "clab-${TOPO}-${n}"; fi
}

vlog() { [ "$VERBOSE" = "1" ] && printf '    [vlog] %s\n' "$*" >&2 || true; }

usage() {
    sed -n '2,/^$/p' "$0" | sed 's/^# //;s/^#//'
    exit 1
}

# --- arg parsing -----------------------------------------------------------

[ $# -ge 1 ] || usage

INSTALL_ROUTE=0
if [ "$1" = "--install-route" ]; then
    INSTALL_ROUTE=1
    shift
fi

[ $# -ge 3 ] || usage
TENANT="$1" ; SRC_ID="$2" ; DST_ID="$3" ; PLANE_ARG="${4:-all}"

case "$TENANT" in
    green|yellow) ;;
    *) echo "tenant must be green|yellow" >&2; exit 1 ;;
esac

if [ "$SRC_ID" = "$DST_ID" ]; then
    echo "src and dst must differ (nothing to trace for self-ping)" >&2
    exit 1
fi

if [ "$PLANE_ARG" = "all" ]; then
    PLANES=(0 1 2 3)
else
    PLANES=("$PLANE_ARG")
fi

# Look up the spine for a given (src,dst) pair from the demo PAIRS table.
# Returns "" if not found; caller will fall back to discovery.
spine_from_pairs() {
    local src="$1" dst="$2"
    local lo=$src hi=$dst
    [ "$lo" -le "$hi" ] || { lo=$dst; hi=$src; }
    local entry e_lo e_hi e_sp
    for entry in "${PAIRS[@]}"; do
        IFS=':' read -r e_lo e_hi e_sp <<<"$entry"
        if [ "$((10#$e_lo))" = "$lo" ] && [ "$((10#$e_hi))" = "$hi" ]; then
            echo "$e_sp"; return
        fi
    done
    echo ""
}

# Pick a spine for non-PAIRS pairs: dst % 8. Deterministic, gives some spread
# across the 8 spines without needing a config table.
spine_default() {
    local dst="$1"
    echo $((dst % 8))
}

# Install host SRv6 routes for one direction on all 4 planes. Idempotent.
#
# args: tenant src_id dst_id spine
install_routes_one_dir() {
    local tenant="$1" src_id="$2" dst_id="$3" spine="$4"
    local src_host="${tenant}-host$(printf '%02d' "$src_id")"
    local dst_leaf_hex
    dst_leaf_hex=$(printf '%x' "$dst_id")
    local base
    [ "$tenant" = green ] && base=bbbb || base=cccc

    local p eth dst_pfx segs
    for p in 0 1 2 3; do
        eth="eth$((p + 1))"
        dst_pfx=$(printf "2001:db8:%s:%x%02x::/64" "$base" "$p" "$dst_id")
        if [ "$tenant" = green ]; then
            segs=$(printf "fc00:%x:f00%s:e00%s:d000::" "$p" "$spine" "$dst_leaf_hex")
        else
            segs=$(printf "fc00:%x:f00%s:e00%s:e009:d001::" "$p" "$spine" "$dst_leaf_hex")
        fi
        docker exec "$(container "$src_host")" \
            ip -6 route replace "$dst_pfx" \
            encap seg6 mode encap.red segs "$segs" dev "$eth" 2>/dev/null
    done
}

# Install both fwd and reverse routes for the (src, dst) pair, on all 4 planes.
maybe_install_routes() {
    [ "$INSTALL_ROUTE" = "1" ] || return 0

    local spine
    spine=$(spine_from_pairs "$SRC_ID" "$DST_ID")
    if [ -z "$spine" ]; then
        spine=$(spine_default "$DST_ID")
        printf '  install: spine=%s (dst %% 8; %s not in PAIRS table)\n' \
            "$spine" "${SRC_ID}<->${DST_ID}"
    else
        printf '  install: spine=%s (from PAIRS table)\n' "$spine"
    fi

    install_routes_one_dir "$TENANT" "$SRC_ID" "$DST_ID" "$spine"
    install_routes_one_dir "$TENANT" "$DST_ID" "$SRC_ID" "$spine"
    printf '  install: routes added for %s-host%02d <-> %s-host%02d on all 4 planes\n' \
        "$TENANT" "$SRC_ID" "$TENANT" "$DST_ID"
}

# --- helpers ---------------------------------------------------------------

# host_addr <tenant> <plane> <id>  ->  2001:db8:bbbb:<P><NN>::2
host_addr() {
    local tenant="$1" plane="$2" id="$3"
    local base
    [ "$tenant" = green ] && base=bbbb || base=cccc
    printf "2001:db8:%s:%x%02x::2" "$base" "$plane" "$id"
}

# expected_sid_at <leg> <tenant> <plane> <dst_leaf_id> <spine>
# Returns what the OUTER IPv6 dst should look like at each capture point.
# leg = host | ingress | spine | egress
expected_sid_at() {
    local leg="$1" tenant="$2" plane="$3" dst_leaf="$4" spine="$5"
    local hex_dst
    hex_dst=$(printf '%x' "$dst_leaf")
    case "$leg" in
        host)
            # host emits encap.red with full SID list
            if [ "$tenant" = green ]; then
                printf "fc00:%x:f00%s:e00%s:d000::" "$plane" "$spine" "$hex_dst"
            else
                printf "fc00:%x:f00%s:e00%s:e009:d001::" "$plane" "$spine" "$hex_dst"
            fi ;;
        ingress)
            # ingress leaf has shifted off f00<S>
            if [ "$tenant" = green ]; then
                printf "fc00:%x:e00%s:d000::" "$plane" "$hex_dst"
            else
                printf "fc00:%x:e00%s:e009:d001::" "$plane" "$hex_dst"
            fi ;;
        spine)
            # spine has additionally shifted off e00<L>
            if [ "$tenant" = green ]; then
                printf "fc00:%x:d000::" "$plane"
            else
                printf "fc00:%x:e009:d001::" "$plane"
            fi ;;
        egress)
            # leaf has shifted off e009 (yellow only); green is decapsulated
            if [ "$tenant" = green ]; then
                echo "(decap; original packet)"
            else
                printf "fc00:%x:d001::" "$plane"
            fi ;;
    esac
}

# Run a single tcpdump on a node:nic for the duration of one ping. Writes to
# a per-tag pcap so multiple captures on different nodes don't collide.
#
# args: node nic filter tag
capture_one_packet() {
    local node="$1" nic="$2" filter="$3" tag="$4"
    local cnode
    cnode=$(container "$node")

    docker exec "$cnode" rm -f "/tmp/trace.${tag}.pcap" "/tmp/trace.${tag}.log" 2>/dev/null
    docker exec -d "$cnode" \
        bash -c "nohup timeout ${TCPDUMP_TIMEOUT} tcpdump -nn -U -Z root \
                 -c 4 -i ${nic} -w /tmp/trace.${tag}.pcap '${filter}' \
                 >/tmp/trace.${tag}.log 2>&1 &" || true
}

stop_capture() {
    local node="$1" tag="$2"
    docker exec "$(container "$node")" \
        pkill -f "tcpdump.*trace.${tag}.pcap" 2>/dev/null
}

# Read first echo-request line from a tagged pcap inside a container.
read_first_echo() {
    local node="$1" tag="$2"
    local cnode
    cnode=$(container "$node")
    docker exec "$cnode" sh -c "
        [ -s /tmp/trace.${tag}.pcap ] || exit 0
        tcpdump -nn -r /tmp/trace.${tag}.pcap 2>/dev/null \
            | awk '/ICMP6, echo request/ { print; exit }'
    " 2>/dev/null
}

# Extract OUTER and INNER IPv6 destinations from a tcpdump line.
# Format examples:
#   IP6 2001:db8:bbbb::2 > fc00:0:f000:e00f:d000:: : IP6 2001:db8:bbbb::2 > 2001:db8:bbbb:f::2: ICMP6, echo request, ...
#   IP6 2001:db8:bbbb::2 > 2001:db8:bbbb:f::2: ICMP6, echo request, ...    (decap'd / native)
extract_dsts() {
    local line="$1"
    local outer="-" inner="-"
    if [ -n "$line" ]; then
        # Case 1: encap'd packet — there are two "IP6 ... > ..." sections.
        # Strip "<ts> IP6 " prefix.
        local rest="${line#* IP6 }"
        # Find first ' > '
        local before_outer_gt="${rest%% > *}"
        local after_outer_gt="${rest#* > }"
        # Outer dst is everything up to ' : ' or ': ' before next 'IP6'
        # Strategy: outer dst is the token after first '>' up to first ':' that
        # precedes whitespace.
        outer=$(printf '%s' "$after_outer_gt" \
                | awk '{print $1}' | sed 's/:$//')

        # Look for an inner section starting with 'IP6 '
        if printf '%s' "$rest" | grep -q ': IP6 '; then
            local inner_part="${rest#*: IP6 }"
            local after_inner_gt="${inner_part#* > }"
            inner=$(printf '%s' "$after_inner_gt" \
                    | awk '{print $1}' | sed 's/:$//')
        else
            # Native (decap'd) — outer in this case is actually the inner
            inner="$outer"
            outer="(decap; native IPv6)"
        fi
    fi
    printf '%s|%s' "$outer" "$inner"
}

# --- main ------------------------------------------------------------------

print_header() {
    local tenant="$1"
    cat <<EOF
============================================================================
  SRv6 flow trace
============================================================================
  tenant : $tenant
  src    : ${tenant}-host$(printf '%02d' "$SRC_ID")
  dst    : ${tenant}-host$(printf '%02d' "$DST_ID")
  planes : ${PLANES[*]}

  At each hop we capture on the wire and show the OUTER IPv6 destination
  (the SID currently on the wire, after any uA shifts performed so far)
  alongside the INNER IPv6 destination (the original tenant address).

  Capture points:
    (0) HostOut — ingress leaf, host-facing port (the wire leaving the source
                  host); shows the freshly-encapsulated packet, full SID list.
    (1) IL     — ingress leaf, uplink toward spine.
    (2) SP     — spine, downlink toward destination leaf.
    (3) EL     — egress leaf, host-facing port toward destination host.

  The transit spine for each plane is determined by the source host's
  installed SRv6 host route (i.e. the f00<S> uSID it encodes). For pairs in
  the demo PAIRS table the spine is known up-front; for others the script
  issues a brief discovery ping to learn the spine from the wire, then
  performs the full 4-hop trace.
EOF
}

# Discover which spine is on the path by capturing the freshly-encapsulated
# packet on the ingress-leaf host port, then parsing the f00<S> nibble out
# of the outer dst.
#
# args: tenant plane
# echoes: spine number (0..7), or "" on failure
discover_spine() {
    local tenant="$1" plane="$2"
    local src_host="${tenant}-host$(printf '%02d' "$SRC_ID")"
    local ingress_leaf="p${plane}-leaf$(printf '%02d' "$SRC_ID")"
    local hostport
    [ "$tenant" = green ] && hostport="Ethernet32" || hostport="Ethernet36"
    local dst_addr
    dst_addr=$(host_addr "$tenant" "$plane" "$DST_ID")

    capture_one_packet "$ingress_leaf" "$hostport" "ip6 proto 41" disco
    sleep "$TCPDUMP_BIND_SLEEP"
    docker exec "$(container "$src_host")" \
        ping -6 -c 1 -W 2 "$dst_addr" >/dev/null 2>&1
    sleep 0.4
    stop_capture "$ingress_leaf" disco

    local line outer_inner outer
    line=$(read_first_echo "$ingress_leaf" disco)
    docker exec "$(container "$ingress_leaf")" \
        rm -f /tmp/trace.disco.pcap /tmp/trace.disco.log 2>/dev/null

    if [ -z "$line" ]; then
        echo ""
        return
    fi
    outer_inner=$(extract_dsts "$line")
    outer="${outer_inner%|*}"
    # Outer should be fc00:<P>:f00<S>:...  — extract <S>
    # Tolerate a leading or absent zero in the plane field.
    local s
    s=$(printf '%s' "$outer" | sed -nE 's/^fc00:[0-9a-f]*:f00([0-9a-f]).*/\1/p')
    echo "$s"
}

trace_one_plane() {
    local tenant="$1" plane="$2"
    local src_host="${tenant}-host$(printf '%02d' "$SRC_ID")"
    local dst_host="${tenant}-host$(printf '%02d' "$DST_ID")"
    local dst_addr
    dst_addr=$(host_addr "$tenant" "$plane" "$DST_ID")

    # Resolve transit spine: prefer the demo PAIRS table; otherwise discover.
    local spine
    spine=$(spine_from_pairs "$SRC_ID" "$DST_ID")
    local spine_source="PAIRS"
    if [ -z "$spine" ]; then
        spine=$(discover_spine "$tenant" "$plane")
        spine_source="discovered"
        if [ -z "$spine" ]; then
            echo
            printf '  --- plane %d --------------------------------------------------------\n' "$plane"
            printf '    spine discovery failed (no encap.red packet seen on host port).\n'
            printf '    Verify the host route exists:\n'
            printf '      docker exec %s ip -6 route get %s\n' "$src_host" "$dst_addr"
            return
        fi
    fi

    local ingress_leaf="p${plane}-leaf$(printf '%02d' "$SRC_ID")"
    local egress_leaf="p${plane}-leaf$(printf '%02d' "$DST_ID")"
    local spine_node="p${plane}-spine0${spine}"

    local spine_egress_nic="Ethernet$((DST_ID * 4))"
    local ingress_uplink="Ethernet0"     # leaf eth1 = uplink toward spine
    # Host-facing port differs by tenant:
    #   green  hosts attach to leaf Ethernet32 (in Vrf-green)
    #   yellow hosts attach to leaf Ethernet36 (default VRF; host-based SRv6)
    local hostport
    if [ "$tenant" = green ]; then
        hostport="Ethernet32"
    else
        hostport="Ethernet36"
    fi

    echo
    printf '  --- plane %d --------------------------------------------------------\n' "$plane"
    printf '    %s -> %s   (via %s [%s], spine downlink %s)\n' \
        "$src_host" "$dst_host" "$spine_node" "$spine_source" "$spine_egress_nic"

    # Start four captures concurrently.
    #   hop0 (host-out): ingress-leaf host port, encap.red (ip6 proto 41)
    #   hop1 (IL):       ingress-leaf uplink, still encap'd (ip6 proto 41)
    #   hop2 (SP):       spine downlink, still encap'd (ip6 proto 41)
    #   hop3 (EL):       egress-leaf host port —
    #     green: native ICMP6 echo (decap'd at leaf via uDT6)
    #     yellow: still SRv6 (one SID layer remains; host does seg6local DT6)
    capture_one_packet "$ingress_leaf" "$hostport"        "ip6 proto 41" hop0
    capture_one_packet "$ingress_leaf" "$ingress_uplink"  "ip6 proto 41" hop1
    capture_one_packet "$spine_node"   "$spine_egress_nic" "ip6 proto 41" hop2
    if [ "$tenant" = green ]; then
        # Filter to ICMP6 echo only (byte 40 is ICMP6 type since no encap)
        capture_one_packet "$egress_leaf" "$hostport" \
            "icmp6 and (ip6[40] == 128 or ip6[40] == 129)" hop3
    else
        capture_one_packet "$egress_leaf" "$hostport" "ip6 proto 41" hop3
    fi
    sleep "$TCPDUMP_BIND_SLEEP"

    # Single ping
    local ping_out ping_rc
    ping_out=$(docker exec "$(container "$src_host")" \
        ping -6 -c 1 -W 2 "$dst_addr" 2>&1)
    ping_rc=$?
    sleep 0.5
    stop_capture "$ingress_leaf" hop0
    stop_capture "$ingress_leaf" hop1
    stop_capture "$spine_node"   hop2
    stop_capture "$egress_leaf"  hop3

    local rtt
    rtt=$(printf '%s' "$ping_out" | awk -F'[ =/]' '/time=/{for(i=1;i<=NF;i++) if($i=="time") {print $(i+1); exit}}')
    [ -z "$rtt" ] && rtt="--"

    if [ "$ping_rc" -ne 0 ]; then
        printf '    PING FAILED (rc=%d):\n%s\n' "$ping_rc" "$ping_out" | sed 's/^/      /'
    else
        printf '    ping rtt: %s ms\n' "$rtt"
    fi

    # Read each capture and pretty-print
    printf '\n    %-9s %-15s %-12s %-50s %s\n' HOP NODE NIC OUTER-DST INNER-DST
    printf '    %-9s %-15s %-12s %-50s %s\n' --------- ---------- ----------- -------------------------------------------------- ---------

    local line outer_inner
    line=$(read_first_echo "$ingress_leaf" hop0)
    outer_inner=$(extract_dsts "$line")
    printf '    %-9s %-15s %-12s %-50s %s\n' "(0) HostOut" "$ingress_leaf" "$hostport"        "${outer_inner%|*}" "${outer_inner#*|}"

    line=$(read_first_echo "$ingress_leaf" hop1)
    outer_inner=$(extract_dsts "$line")
    printf '    %-9s %-15s %-12s %-50s %s\n' "(1) IL"      "$ingress_leaf" "$ingress_uplink"  "${outer_inner%|*}" "${outer_inner#*|}"

    line=$(read_first_echo "$spine_node" hop2)
    outer_inner=$(extract_dsts "$line")
    printf '    %-9s %-15s %-12s %-50s %s\n' "(2) SP"      "$spine_node"   "$spine_egress_nic" "${outer_inner%|*}" "${outer_inner#*|}"

    line=$(read_first_echo "$egress_leaf" hop3)
    outer_inner=$(extract_dsts "$line")
    printf '    %-9s %-15s %-12s %-50s %s\n' "(3) EL"      "$egress_leaf"  "$hostport"         "${outer_inner%|*}" "${outer_inner#*|}"

    # Expected key
    printf '\n    Expected (encoded by uSID shift-and-forward):\n'
    printf '      (0) host emits encap.red SID list      -> outer dst = %s\n' \
        "$(expected_sid_at host "$tenant" "$plane" "$DST_ID" "$spine")"
    printf '      (1) ingress leaf shifts off  f00%s     -> outer dst = %s\n' \
        "$spine" "$(expected_sid_at ingress "$tenant" "$plane" "$DST_ID" "$spine")"
    printf '      (2) spine        shifts off  e00%x     -> outer dst = %s\n' \
        "$DST_ID" "$(expected_sid_at spine "$tenant" "$plane" "$DST_ID" "$spine")"
    if [ "$tenant" = green ]; then
        printf '      (3) egress leaf decap (uDT6, vrf-green) -> %s\n' \
            "$(expected_sid_at egress "$tenant" "$plane" "$DST_ID" "$spine")"
    else
        printf '      (3) egress leaf shifts off  e009       -> outer dst = %s\n' \
            "$(expected_sid_at egress "$tenant" "$plane" "$DST_ID" "$spine")"
        printf '          (host then performs seg6local End.DT6 to decap)\n'
    fi

    # Cleanup pcaps
    for tag in hop0 hop1 hop2 hop3; do
        case "$tag" in
            hop0|hop1) docker exec "$(container "$ingress_leaf")" rm -f "/tmp/trace.${tag}.pcap" "/tmp/trace.${tag}.log" 2>/dev/null ;;
            hop2)      docker exec "$(container "$spine_node")"   rm -f "/tmp/trace.${tag}.pcap" "/tmp/trace.${tag}.log" 2>/dev/null ;;
            hop3)      docker exec "$(container "$egress_leaf")"  rm -f "/tmp/trace.${tag}.pcap" "/tmp/trace.${tag}.log" 2>/dev/null ;;
        esac
    done
}

main() {
    print_header "$TENANT"
    if [ "$INSTALL_ROUTE" = "1" ]; then
        echo
        maybe_install_routes
    fi
    for p in "${PLANES[@]}"; do
        trace_one_plane "$TENANT" "$p"
    done
    echo
    echo "============================================================================"
}

main
