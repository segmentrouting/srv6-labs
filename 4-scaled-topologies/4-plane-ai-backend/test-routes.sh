#!/usr/bin/env bash
# test-routes.sh — install host SRv6 routes, run pings, capture on spines,
# emit a path/result summary. Subcommands:
#
#   ./test-routes.sh routes      install host SRv6 encap routes (8 pairs, both colors)
#   ./test-routes.sh clean       remove the routes installed by 'routes'
#   ./test-routes.sh demo        run all pings + tcpdump captures, print summary
#   ./test-routes.sh test <pair> <plane>   run a single pair on a single plane
#                                          pair = green-00-15 | yellow-03-12 | ...
#                                          plane = 0|1|2|3
#
# Assumes the lab is up and configs have been pushed via ./config.sh all.

set -uo pipefail

TOPO="${TOPO:-sonic-docker-4p-8x16}"
PING_COUNT="${PING_COUNT:-4}"
PING_INTERVAL="${PING_INTERVAL:-0.3}"
TCPDUMP_TIMEOUT="${TCPDUMP_TIMEOUT:-8}"
VERBOSE="${VERBOSE:-0}"

vlog() {
    [ "$VERBOSE" = "1" ] && printf '    [vlog] %s\n' "$*" >&2 || true
}

# ------------------------------------------------------------------
# Test pairs: low-id <-> high-id, with a chosen forward-path spine
# distributed across the 8 spines so a full demo run lights up every
# spine in every plane.
# Format: <low_id>:<high_id>:<spine>
# ------------------------------------------------------------------
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

PLANES=(0 1 2 3)

# ------------------------------------------------------------------
# helpers
# ------------------------------------------------------------------

container() {
    # resolve a node short-name to its docker container name
    local n="$1"
    if docker inspect "$n" &>/dev/null; then
        echo "$n"
    else
        echo "clab-${TOPO}-${n}"
    fi
}

host_prefix() {
    # color, plane, host-id-decimal -> "2001:db8:bbbb:<P><NN>"
    local color="$1" plane="$2" hid_dec="$3"
    local base
    if [ "$color" = "green" ]; then base="bbbb"; else base="cccc"; fi
    printf "2001:db8:%s:%x%02x" "$base" "$plane" "$hid_dec"
}

dst_prefix64() {
    # color, plane, hid_dec -> /64 prefix string
    echo "$(host_prefix "$1" "$2" "$3")::/64"
}

dst_addr() {
    # color, plane, hid_dec -> single host address
    echo "$(host_prefix "$1" "$2" "$3")::2"
}

# uSID list builder
#   green:  fc00:000<P>:f00<S>:e00<L>:d000::
#   yellow: fc00:000<P>:f00<S>:e00<L>:e009:d001::
build_segs() {
    local color="$1" plane="$2" spine="$3" remote_leaf="$4"
    local seg="fc00:000${plane}:f00${spine}:e00${remote_leaf}"
    if [ "$color" = "green" ]; then
        echo "${seg}:d000::"
    else
        echo "${seg}:e009:d001::"
    fi
}

leaf_for() {
    # the leaf number (decimal) a host with id N attaches to is N (one host
    # per leaf number). Returns the hex digit used in SID encoding.
    printf "%x" "$1"
}

# ------------------------------------------------------------------
# routes
# ------------------------------------------------------------------

install_routes_for_pair() {
    local color="$1" lo_dec="$2" hi_dec="$3" spine="$4"
    local lo_host="${color}-host$(printf '%02d' "$lo_dec")"
    local hi_host="${color}-host$(printf '%02d' "$hi_dec")"
    local lo_leaf hi_leaf
    lo_leaf=$(leaf_for "$lo_dec")
    hi_leaf=$(leaf_for "$hi_dec")

    for p in "${PLANES[@]}"; do
        local eth="eth$((p + 1))"
        local fwd_dst rev_dst fwd_segs rev_segs

        fwd_dst=$(dst_prefix64 "$color" "$p" "$hi_dec")
        rev_dst=$(dst_prefix64 "$color" "$p" "$lo_dec")
        fwd_segs=$(build_segs "$color" "$p" "$spine" "$hi_leaf")
        rev_segs=$(build_segs "$color" "$p" "$spine" "$lo_leaf")

        docker exec "$(container "$lo_host")" \
            ip -6 route replace "$fwd_dst" \
            encap seg6 mode encap.red segs "$fwd_segs" dev "$eth" 2>/dev/null
        docker exec "$(container "$hi_host")" \
            ip -6 route replace "$rev_dst" \
            encap seg6 mode encap.red segs "$rev_segs" dev "$eth" 2>/dev/null
    done
    echo "  $color  $(printf '%-15s' "$lo_host <-> $hi_host")  via spine${spine} (all 4 planes)"
}

cmd_routes() {
    echo "=== Installing SRv6 host routes ==="
    for color in green yellow; do
        for entry in "${PAIRS[@]}"; do
            IFS=':' read -r lo hi sp <<<"$entry"
            install_routes_for_pair "$color" "$((10#$lo))" "$((10#$hi))" "$sp"
        done
    done
    echo "=== done ==="
}

cmd_clean() {
    echo "=== Removing SRv6 host routes ==="
    for color in green yellow; do
        for entry in "${PAIRS[@]}"; do
            IFS=':' read -r lo hi _ <<<"$entry"
            local lo_dec=$((10#$lo)) hi_dec=$((10#$hi))
            local lo_host="${color}-host$(printf '%02d' "$lo_dec")"
            local hi_host="${color}-host$(printf '%02d' "$hi_dec")"
            for p in "${PLANES[@]}"; do
                docker exec "$(container "$lo_host")" \
                    ip -6 route del "$(dst_prefix64 "$color" "$p" "$hi_dec")" 2>/dev/null
                docker exec "$(container "$hi_host")" \
                    ip -6 route del "$(dst_prefix64 "$color" "$p" "$lo_dec")" 2>/dev/null
            done
        done
    done
    echo "=== done ==="
}

# ------------------------------------------------------------------
# ping + tcpdump driver
# ------------------------------------------------------------------

# Run one ping with a tcpdump on the egress spine port toward the destination
# leaf. Returns: ping_rtt_avg, packet_count_seen, sample_outer_dst.
#
# Capture interface mapping:
#   In the clab YAML, spine eth1..eth16 face leaf00..leaf15. Inside SONiC
#   those NICs are renamed to Ethernet0, Ethernet4, ..., Ethernet60. So the
#   spine NIC facing leaf L is Ethernet<L*4>. The destination leaf number is
#   <hi_dec> for the forward path.
run_one_test() {
    local color="$1" lo_dec="$2" hi_dec="$3" spine="$4" plane="$5"
    local src_host="${color}-host$(printf '%02d' "$lo_dec")"
    local dst_addr_str
    dst_addr_str=$(dst_addr "$color" "$plane" "$hi_dec")
    local spine_node="p${plane}-spine0${spine}"
    local spine_egress_nic="Ethernet$((hi_dec * 4))"

    local capfile
    capfile=$(mktemp -t srv6demo.XXXXXX.pcap)
    local cap_summary
    cap_summary=$(mktemp -t srv6demo.XXXXXX.txt)

    vlog "spine=$spine_node nic=$spine_egress_nic src=$src_host dst=$dst_addr_str"

    # Pre-clean any leftover artifacts inside the spine.
    docker exec "$(container "$spine_node")" \
        rm -f /tmp/srv6demo.pcap /tmp/srv6demo.tcpdump.log 2>/dev/null

    # Capture filter: match the encap'd echo traffic on the spine→leaf wire.
    # The packets here are SRv6 encap.red, i.e. outer IPv6 with next-header 41
    # (IPv6-in-IPv6) carrying the original ICMPv6 echo. So we filter on the
    # outer next-header. NDP / RA / MLD are next-header 58 (ICMPv6) and won't
    # match. (Earlier 'icmp6 and ip6[40]==128|129' was wrong: byte 40 is the
    # *inner* IPv6 version/TC field for encapped packets, never 128/129.)
    # -Z root: don't try to drop privileges (the 'tcpdump' user may not exist
    #          in the SONiC container, which causes a silent exit).
    # nohup + & inside the container so the bash from `docker exec -d` can
    # exit cleanly without HUP'ing tcpdump.
    docker exec -d "$(container "$spine_node")" \
        bash -c "nohup timeout ${TCPDUMP_TIMEOUT} tcpdump -nn -U -Z root \
                 -i ${spine_egress_nic} -w /tmp/srv6demo.pcap \
                 'ip6 proto 41' \
                 >/tmp/srv6demo.tcpdump.log 2>&1 &" || true
    sleep 1.5   # let tcpdump bind (observed ~1s on docker-sonic-vs)

    if [ "$VERBOSE" = "1" ]; then
        vlog "tcpdump processes on spine after sleep:"
        docker exec "$(container "$spine_node")" pgrep -af tcpdump >&2 || vlog "  (none running)"
        vlog "pcap state right before ping:"
        docker exec "$(container "$spine_node")" ls -la /tmp/srv6demo.pcap /tmp/srv6demo.tcpdump.log >&2 2>/dev/null || true
    fi

    # Run the ping
    local ping_out ping_rc
    ping_out=$(docker exec "$(container "$src_host")" \
        ping -6 -c "$PING_COUNT" -i "$PING_INTERVAL" -W 2 "$dst_addr_str" 2>&1)
    ping_rc=$?

    sleep 0.4   # let trailing packets reach pcap
    docker exec "$(container "$spine_node")" pkill -f 'tcpdump.*srv6demo' 2>/dev/null

    if [ "$VERBOSE" = "1" ]; then
        vlog "pcap state after ping+kill:"
        docker exec "$(container "$spine_node")" ls -la /tmp/srv6demo.pcap >&2 2>/dev/null || vlog "  (no pcap file)"
        vlog "tcpdump.log contents:"
        docker exec "$(container "$spine_node")" cat /tmp/srv6demo.tcpdump.log >&2 2>/dev/null || true
    fi

    # Pull and parse the pcap
    docker cp "$(container "$spine_node")":/tmp/srv6demo.pcap "$capfile" 2>/dev/null
    docker exec "$(container "$spine_node")" rm -f /tmp/srv6demo.pcap /tmp/srv6demo.tcpdump.log 2>/dev/null

    vlog "local pcap: $(ls -la "$capfile" 2>/dev/null || echo MISSING)"

    local pkt_count=0 sample_dst="-"
    if [ -s "$capfile" ]; then
        # Use tcpdump on host if available; fall back to running it inside the spine.
        if command -v tcpdump &>/dev/null; then
            tcpdump -nn -r "$capfile" 2>/dev/null > "$cap_summary"
        else
            docker cp "$capfile" "$(container "$spine_node")":/tmp/srv6demo.pcap
            docker exec "$(container "$spine_node")" \
                tcpdump -nn -r /tmp/srv6demo.pcap 2>/dev/null > "$cap_summary"
            docker exec "$(container "$spine_node")" rm -f /tmp/srv6demo.pcap
        fi
        pkt_count=$(grep -c 'ICMP6, echo' "$cap_summary" 2>/dev/null)
        pkt_count=${pkt_count:-0}
        # Sample the OUTER IPv6 destination (the SRv6 SID currently on the wire)
        # from the first echo-request line we see. Format is:
        #   <ts> IP6 <src> > <dst>: ICMP6, echo request, ...
        # We want <dst>, which is the token immediately before the colon-ICMP6.
        sample_dst=$(awk '/ICMP6, echo request/ {
                              for (i = 1; i <= NF; i++) {
                                  if ($i == ">" && (i + 1) <= NF) {
                                      d = $(i + 1)
                                      sub(/:$/, "", d)
                                      print d
                                      exit
                                  }
                              }
                          }' "$cap_summary" | tr -d '\r\n ')
        [ -z "$sample_dst" ] && sample_dst="-"
    fi

    local rtt_avg
    rtt_avg=$(echo "$ping_out" | awk -F'[/=]' '/rtt|round-trip/{print $5; exit}')
    [ -z "$rtt_avg" ] && rtt_avg="--"

    local recv
    recv=$(echo "$ping_out" | awk '/packets transmitted/{print $4}')
    [ -z "$recv" ] && recv=0

    rm -f "$capfile" "$cap_summary"

    # Emit one CSV row to stdout for the demo summary collector.
    # Fields: color,plane,src,dst,spine,recv/sent,rtt_avg,pkts_on_spine,sample_outer_dst,ping_rc
    printf '%s,%s,%s,%s,%s,%s/%s,%s,%s,%s,%s\n' \
        "$color" "$plane" "$src_host" \
        "${color}-host$(printf '%02d' "$hi_dec")" \
        "$spine_node" "$recv" "$PING_COUNT" \
        "$rtt_avg" "$pkt_count" "$sample_dst" "$ping_rc"
}

cmd_test() {
    # Single-pair single-plane runner (for ad-hoc use).
    local pair="$1" plane="$2"
    # pair format: green-00-15 or yellow-03-12
    local color lo hi
    color=$(echo "$pair" | cut -d- -f1)
    lo=$(echo "$pair" | cut -d- -f2)
    hi=$(echo "$pair" | cut -d- -f3)
    # find the spine for this pair
    local sp=""
    for entry in "${PAIRS[@]}"; do
        IFS=':' read -r e_lo e_hi e_sp <<<"$entry"
        if [ "$e_lo" = "$lo" ] && [ "$e_hi" = "$hi" ]; then sp="$e_sp"; break; fi
    done
    [ -z "$sp" ] && { echo "unknown pair: $pair"; exit 1; }

    echo "color=$color plane=$plane lo=$lo hi=$hi spine=$sp"
    run_one_test "$color" "$((10#$lo))" "$((10#$hi))" "$sp" "$plane"
}

# ------------------------------------------------------------------
# full demo: routes already installed, sweep all pairs x all planes
# ------------------------------------------------------------------

cmd_demo() {
    local results
    results=$(mktemp -t srv6demo.results.XXXXXX)

    echo "=== SRv6 fabric demo: 16 pairs x 4 planes = 64 runs ==="
    echo "Pings: ${PING_COUNT} per run, interval ${PING_INTERVAL}s"
    echo "Capture: tcpdump on egress spine port (${TCPDUMP_TIMEOUT}s window per run)"
    echo

    local total=0 ok=0
    for color in green yellow; do
        for entry in "${PAIRS[@]}"; do
            IFS=':' read -r lo hi sp <<<"$entry"
            local lo_dec=$((10#$lo)) hi_dec=$((10#$hi))
            for p in "${PLANES[@]}"; do
                total=$((total + 1))
                printf '  [%2d/64] %s %s%s <-> %s%s plane %d via spine%s ... ' \
                    "$total" "$color" "$lo" "$([ "$color" = green ] && echo '' || echo '')" \
                    "$hi" "" "$p" "$sp"
                local row
                row=$(run_one_test "$color" "$lo_dec" "$hi_dec" "$sp" "$p")
                echo "$row" >> "$results"
                # quick OK/FAIL hint
                local recv pkts
                recv=$(echo "$row" | awk -F, '{print $6}' | cut -d/ -f1)
                pkts=$(echo "$row" | awk -F, '{print $9}')
                if [ "$recv" -gt 0 ]; then
                    printf 'ping %s, spine pkts %s\n' "$recv/$PING_COUNT" "$pkts"
                    ok=$((ok + 1))
                else
                    printf 'FAIL (no replies)\n'
                fi
            done
        done
    done

    print_summary "$results" "$ok" "$total"
    rm -f "$results"
}

# ------------------------------------------------------------------
# summary report
# ------------------------------------------------------------------

print_summary() {
    local results="$1" ok="$2" total="$3"

    echo
    echo "============================================================================"
    echo "  SRv6 4-plane fabric — demo summary"
    echo "============================================================================"
    printf '  passed: %d / %d\n\n' "$ok" "$total"

    printf '  %-7s %-5s %-15s %-15s %-12s %-7s %-8s %-5s %s\n' \
        COLOR PLANE SRC DST EGR-SPINE RX/TX RTT_avg PKTS OUTER-DST-SAMPLE
    printf '  %-7s %-5s %-15s %-15s %-12s %-7s %-8s %-5s %s\n' \
        ------ ----- --- --- --------- ----- ------- ---- ----------------
    while IFS=, read -r color plane src dst spine rxtx rtt pkts sdst _; do
        printf '  %-7s %-5s %-15s %-15s %-12s %-7s %-8s %-5s %s\n' \
            "$color" "$plane" "$src" "$dst" "$spine" "$rxtx" "$rtt" "$pkts" "$sdst"
    done < "$results"

    echo
    echo "  Path encoding key:"
    echo "    green  : <src> -> ingress-leaf -> spine -> egress-leaf -uDT6-> <dst>"
    echo "             SID list: fc00:000<P>:f00<S>:e00<L>:d000::"
    echo "    yellow : <src> -> ingress-leaf -> spine -> egress-leaf -uA-> <dst>(decap)"
    echo "             SID list: fc00:000<P>:f00<S>:e00<L>:e009:d001::"
    echo "============================================================================"
}

# ------------------------------------------------------------------
# entrypoint
# ------------------------------------------------------------------

main() {
    local cmd="${1:-}"
    shift || true
    case "$cmd" in
        routes) cmd_routes "$@" ;;
        clean)  cmd_clean "$@" ;;
        demo)   cmd_demo "$@" ;;
        test)
            [ $# -eq 2 ] || { echo "usage: $0 test <pair> <plane>"; exit 1; }
            cmd_test "$@"
            ;;
        *)
            cat <<USAGE
usage: $0 <subcommand>

  routes               install SRv6 host routes (16 pairs x 4 planes)
  clean                remove the routes installed by 'routes'
  demo                 run pings + spine-egress captures across all pairs/planes,
                       print summary table
  test <pair> <plane>  one-shot run, e.g.: $0 test green-00-15 0
                       pairs (lo-hi): 00-15 01-14 02-13 03-12 04-11 05-10 06-09 07-08

env:
  TOPO=$TOPO
  PING_COUNT=$PING_COUNT  PING_INTERVAL=$PING_INTERVAL  TCPDUMP_TIMEOUT=$TCPDUMP_TIMEOUT
  VERBOSE=$VERBOSE   (set to 1 to see per-step diagnostics on stderr)
USAGE
            exit 1
            ;;
    esac
}

main "$@"
