# `trace-flow.sh` — per-hop SRv6 uSID walkthrough

A diagnostic tool that takes a single tenant flow (src host → dst host) and shows
the SRv6 outer-IPv6 destination at every hop along the forward path, side-by-side
with what the uSID compression model says it *should* be at that point.

The point isn't to test connectivity (`test-routes.sh` does that). It's to make
the **shift-and-forward** behavior of uSID concrete: you see one uSID consumed
per hop, in real captured packets, and can compare against the predicted SID at
each shift point.

## What it captures

For each plane, the script runs four `tcpdump` instances simultaneously and
fires one ICMPv6 echo across the fabric:

```
                     leaf uplink           spine downlink
   src host ──────►  ingress leaf ───────► spine ──────────► egress leaf ──────► dst host
       │              │  Ethernet0         │  Ethernet<L*4>    │  Ethernet32/36
       │              │                    │                   │
   (0) HostOut    (1) IL                (2) SP              (3) EL
   host port      uplink to spine       downlink to leaf    host port
```

| Tap | Where | Shows |
|---|---|---|
| **(0) HostOut** | ingress leaf, host port (Ethernet32 green / Ethernet36 yellow) | Packet as the host emitted it. Full SID list, no shifts yet. |
| **(1) IL** | ingress leaf, uplink Ethernet0 | What the leaf forwards toward the spine. The first uSID (`f00<S>`) has been consumed. |
| **(2) SP** | spine, downlink Ethernet`<L*4>` toward egress leaf | What the spine forwards on. The next uSID (`e00<L>`) has been consumed. |
| **(3) EL** | egress leaf, host port | Green: decapsulated (inner packet). Yellow: still has the host-DT SID stack (`e009:d001::`). |

## Usage

```text
./trace-flow.sh [--install-route] <tenant> <src_id> <dst_id> [plane|all]

  --install-route   if the src host doesn't have an SRv6 route to dst,
                    install one (forward + reverse, all 4 planes) before
                    tracing. Idempotent. Routes persist after exit.
  tenant            green | yellow
  src_id, dst_id    0..15 (host id, also leaf id)
  plane             0 | 1 | 2 | 3 | all   (default: all)
```

### Examples

```bash
# PAIRS pair, all four planes
./trace-flow.sh green 0 15

# One plane only
./trace-flow.sh yellow 3 12 2

# Arbitrary pair not in PAIRS — routes auto-installed
./trace-flow.sh --install-route yellow 0 12

# Same, green
./trace-flow.sh --install-route green 2 9 0
```

## How spine selection works

The script needs to know which spine the flow will traverse so it can place tap
(2) on the correct spine container and downlink. It picks in this order:

1. **PAIRS table** — if `(min(src,dst), max(src,dst))` matches an entry in the
   demo `PAIRS` table, that spine is used. Header tag: `[PAIRS]`.
2. **Discovery** — otherwise, place a one-packet capture on the ingress leaf's
   host port, fire one echo, and parse `f00<S>` from the encap.red outer
   destination. Header tag: `[discovered]`.
3. **`--install-route` fallback** — when installing, if the pair isn't in
   PAIRS, pick `spine = dst_id % 8`. Deterministic, gives some spread across
   the 8 spines without a config table. Discovery will then confirm this on
   the first plane's trace.

## What `--install-route` does

For an arbitrary `(src_id, dst_id)` pair not in the demo PAIRS table, neither
host has SRv6 routes to the other, so discovery returns nothing and the trace
fails. `--install-route` fixes this by installing host SRv6 routes:

- **Both directions**: `src → dst` and `dst → src`.
- **All four planes**: 8 routes total, one per `(direction, plane)`.
- **Idempotent**: uses `ip -6 route replace`. Safe to re-run.
- **Persistent**: routes stay installed after the script exits. Re-running the
  trace is cheap. To clean up, either delete by hand or extend
  `test-routes.sh clean` to know about the new pair.

The encap SID list installed mirrors what the controller would push:

- Green: `fc00:<P>:f00<S>:e00<L>:d000::`
- Yellow: `fc00:<P>:f00<S>:e00<L>:e009:d001::`

where `<S>` is the chosen spine and `<L>` is the destination leaf id.

## Reading the output

For each plane the script prints the four taps in order. Each tap shows a
captured outer IPv6 destination (the "Actual" line) next to the predicted SID
at that shift point (the "Expected" line). Mismatches mean either the SID
list installed on the host is wrong, the ASIC isn't shifting (possible NPL
bug), or the tap landed on the wrong port (script bug).

Example slice (yellow, plane 1, host 0 → host 15, spine 0):

```
  --- plane 1 --------------------------------------------------------
    yellow-host00 -> yellow-host15   (via p1-spine00 [PAIRS], spine downlink Ethernet60)

    (0) HostOut  ingress leaf p1-leaf00, host port Ethernet36
        Actual   : fc00:0001:f000:e00f:e009:d001::
        Expected : fc00:0001:f000:e00f:e009:d001::

    (1) IL       ingress leaf p1-leaf00, uplink Ethernet0
        Actual   : fc00:0001:e00f:e009:d001::
        Expected : fc00:0001:e00f:e009:d001::

    (2) SP       spine p1-spine00, downlink Ethernet60
        Actual   : fc00:0001:e009:d001::
        Expected : fc00:0001:e009:d001::

    (3) EL       egress leaf p1-leaf0f, host port Ethernet36
        Actual   : fc00:0001:d001::
        Expected : fc00:0001:d001::
```

For green at tap (3) the Actual is the inner decapsulated packet
(`2001:db8:bbbb:<P><src>::2`), since the egress leaf's `d000` uDT6 SID
strips the outer header and looks up in `Vrf-green`.

## Environment knobs

| Variable | Default | Purpose |
|---|---|---|
| `TOPO` | `sonic-docker-4p-8x16` | Containerlab topology prefix; needed to resolve `clab-<TOPO>-<node>` container names. |
| `TCPDUMP_TIMEOUT` | `6` | Seconds each tcpdump runs. Bump if you see "no packet" on slow hosts. |
| `TCPDUMP_BIND_SLEEP` | `1.5` | Seconds to wait after spawning tcpdump before firing the ping (so the bpf bind has a chance to take effect). |
| `VERBOSE` | `0` | Set to `1` to print per-step diagnostics on stderr. |

## Implementation notes

- All `tcpdump` invocations run under `docker exec -d` with `nohup ... &` and
  `-Z root`. Without this combination, capture exits silently the moment
  `docker exec` returns.
- The BPF filter is `ip6 proto 41` (SRv6 encap.red is IPv6-in-IPv6). A naive
  `icmp6` filter misses everything because byte 40 of the outer header is the
  inner IPv6 version field, not an ICMP type.
- SONiC renames clab `eth1..eth16` to `Ethernet0/4/.../60`. The spine NIC
  facing leaf `L` is `Ethernet$((L * 4))`. Host-facing leaf NICs are fixed at
  Ethernet32 (green) and Ethernet36 (yellow) to match the function-bit
  convention `e<NIC ordinal>` used throughout the lab.

## Related

- `test-routes.sh` — installs PAIRS routes, runs 64-pair ping suite, prints
  one-line per-pair OUTER-DST samples.
- `README.md`, `design-appendix.md` — fabric design and SID conventions.
