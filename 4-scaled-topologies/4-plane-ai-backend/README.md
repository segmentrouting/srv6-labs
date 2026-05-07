# 4-Plane SRv6 GPU Fabric (8-spine × 16-leaf × 4 planes)

A controller-driven, BGP-free SRv6 (uSID) lab built on top of `docker-sonic-vs` +
Containerlab. Models a small slice of a hyperscale AI backend fabric: 4
independent network planes, each a full 8 × 16 Clos, with multi-homed tenant
hosts uplinked into every plane.

```
                ┌──────── plane 0 (8s × 16l) ───────┐
                │   spines │  leaves │  /32 block   │
                ├──────────┼─────────┼──────────────┤
green-host00 ───┤ p0-spine │ p0-leaf │ fc00:0000::/32
green-host00 ───┤ p1-spine │ p1-leaf │ fc00:0001::/32  cluster
green-host00 ───┤ p2-spine │ p2-leaf │ fc00:0002::/32   /30
green-host00 ───┤ p3-spine │ p3-leaf │ fc00:0003::/32
yellow-host00 ──┘                                       │
                                                        │
                                          fc00:0000::/30 — cluster aggregate
```

- **96 SONiC switches** (32 spines + 64 leaves)
- **32 Alpine hosts** (16 green + 16 yellow), each with 4 NIC uplinks
- **640 veth pairs** (512 fabric + 128 host)
- **No BGP, no IGP** — every transit FIB entry is a static route or an SRv6 uA
  SID; the controller installs end-to-end SR policies for tenant traffic.

## Why this design

The lab demonstrates several patterns that recur in hyperscale GPU fabrics:

1. **Multi-plane Clos** — each plane is an independent failure / scheduling
   domain. Hosts have one NIC into each plane; flows are pinned to a plane by
   the controller, not by ECMP.
2. **Per-plane uSID block** — each plane gets its own `/32` so plane identity
   is part of the destination prefix, not buried in node bits. Aggregates
   cleanly at the WAN: one `/30` per cluster.
3. **Function-bit conventions across the fabric** — `f00<S>` always means
   "this leaf's uA toward spine S", `e00<L>` always means "this spine's uA
   toward leaf L", `d000`/`d001` are tenant-ID uDT6 SIDs. A controller
   reading any SID list can tell what each label does without per-node state.
4. **Three SRv6 multi-tenancy models** (carried over from
   `../01-sonic-vs/README.md`):
    - **Network-based** (blue): leaf-encap, leaf-decap. *Removed in this lab.*
    - **Hybrid** (green): host-encap, leaf-decap into `Vrf-green` via uDT6.
    - **Host-based** (yellow): host-encap, host-decap. Leaves are pure transit;
      yellow hosts run `seg6local End.DT6` on every plane NIC.

## Addressing

### IPv6 layout

| Element | Pattern | Example |
|---|---|---|
| Cluster aggregate | `fc00:0000::/30` | covers all 4 planes |
| Plane block | `fc00:000<P>::/32` | plane 2 → `fc00:0002::/32` |
| Spine locator | `fc00:000<P>:1<S>::/48` | p2-spine03 → `fc00:0002:13::/48` |
| Leaf locator | `fc00:000<P>:2<L>::/48` | p2-leaf10 → `fc00:0002:2a::/48` |
| Leaf uA → spine | `fc00:000<P>:f00<S>::/48` | p2 leaf, toward spine03 → `fc00:0002:f003::/48` |
| Spine uA → leaf | `fc00:000<P>:e00<L>::/48` | p2 spine, toward leaf10 → `fc00:0002:e00a::/48` |
| Green tenant uDT6 | `fc00:000<P>:d000::/48` | per-plane on every leaf, decap into `Vrf-green` |
| Yellow tenant uDT6 | `fc00:000<P>:d001::/48` | per-plane on every yellow host, `End.DT6 table 0` |
| Fabric P2P | `2001:db8:fab:<S*16+L>::/127` | reused per plane (planes are L2-isolated) |
| Green host uplink | `2001:db8:bbbb:<P><NN>::/64` | green-host15 plane 3 → `2001:db8:bbbb:30f::/64` |
| Yellow host uplink | `2001:db8:cccc:<P><NN>::/64` | yellow-host00 plane 0 → `2001:db8:cccc:000::/64` |
| Host side | `...::2/64` |  |
| Leaf gateway | `...::1/64` |  |

`<P>` = plane 0–3 (hex), `<S>` = spine 0–7, `<L>` = leaf 0–f, `<NN>` = host 00–15 (hex byte).

### IPv4 (loopback only — for FRR router-id)

| Element | Pattern |
|---|---|
| Spine loopback | `10.0.<P>.<S+1>` |
| Leaf loopback | `10.1.<P>.<L+1>` |

### Reading a SR-policy SID list

A path "deliver to p2-leaf10, choose plane 2, egress toward p2-spine03,
then decap into green at the next hop" encodes as a single uSID-compressed
IPv6 destination:

```
fc00:0002:2a:f003:d000::
└──┬───┘ └┬┘ └┬─┘ └┬─┘
   │      │   │    └─ d000  : tenant-ID green → Vrf-green at egress leaf
   │      │   └────── f003  : leaf uA toward spine 03 (in plane 2)
   │      └────────── 2a    : leaf locator (leaf 0a = leaf 10)
   └───────────────── 0002  : plane 2 block
```

Every label is unambiguous in isolation.

## Topology counts

| | Count |
|---|---|
| Planes | 4 |
| Spines per plane | 8 |
| Leaves per plane | 16 |
| Hosts per color | 16 |
| Total SONiC nodes | 96 |
| Total host nodes | 32 |
| Fabric links | 4 × 8 × 16 = 512 |
| Host links | 4 × 16 × 2 = 128 |
| **Total veth pairs** | **640** |

Each `docker-sonic-vs` container needs roughly 1–1.5 GB resident memory and a
portion of one CPU. Plan on **~150 GB RAM** and a multi-socket host (or scale
the lab down — see "Reducing scale" below).

## Files

| File | Purpose |
|---|---|
| `generate_fabric.py` | Single source of truth — generates `topology.clab.yaml` and `config/<node>/{config_db.json,frr.conf}` |
| `topology.clab.yaml` | Containerlab topology (generated) |
| `config/<node>/` | Per-node SONiC `config_db.json` and FRR `frr.conf` (generated) |
| `config.sh` | Pushes generated configs into running SONiC containers |

## Deployment

### 1. Pull required images

```bash
docker pull docker-sonic-vs:latest                # SONiC VS (build or pull)
docker pull iejalapeno/alpine-srv6:1.0            # Alpine + iproute2 SRv6 + tcpdump
```

### 2. Generate configs - already complete in [config](./config/), but re-run script if you want to change the topology

```bash
python3 generate_fabric.py
```

Writes the topology and 96 sets of node configs.

### 3. Bring up the lab

```bash
sudo containerlab deploy -t topology.clab.yaml
```

This stage:

- Boots 96 SONiC + 32 Alpine containers in dependency order
- Creates 640 veth pairs
- Applies the host `exec:` blocks (host IP addresses, plane routes, yellow
  `seg6local`)

Expect 5–15 minutes on a well-provisioned host.

### 4. Push SONiC configs

```bash
./config.sh all
```

This iterates every SONiC node and:

1. Creates `Loopback0` if missing
2. Copies `config_db.json` to `/etc/sonic/` and runs `sonic-cfggen --write-to-db`
3. Restarts SONiC services (`supervisorctl restart all`)
4. Sets up `vrfdefault`, `sr0`, IPv6 forwarding sysctls
5. Brings every port up (`config interface startup`)
6. Strips any default BGP instance (this lab has no BGP)
7. Loads `frr.conf` via `vtysh -f`

Other targets:

```bash
./config.sh gen           # regenerate (same as step 2)
./config.sh leaf          # leaf tier only
./config.sh spine         # spine tier only
./config.sh p2-leaf0a     # one node
```

### 5. Verify

```bash
# Pick any leaf
docker exec clab-sonic-docker-4p-8x16-p2-leaf10 vtysh -c 'show segment-routing srv6 sid'
docker exec clab-sonic-docker-4p-8x16-p2-leaf10 vtysh -c 'show ipv6 route summary'

# A green host's view (4 plane routes, one per uplink)
docker exec clab-sonic-docker-4p-8x16-green-host00 ip -6 route | grep fc00

# A yellow host should have 4 seg6local entries
docker exec clab-sonic-docker-4p-8x16-yellow-host00 ip -6 route | grep seg6local
```

### Tear down

```bash
sudo containerlab destroy -t topology.clab.yaml
```

## Routing model: no BGP, no IGP

Every node's `frr.conf` carries:

- A single SRv6 locator (`MAIN`) with `behavior usid`
- Static uA SIDs for each connected neighbor (in `f00<S>` / `e00<L>` form)
- Static uDT6 SID `d000` on leaves → `Vrf-green` (green decap)
- Static IPv6 routes for every other locator in the same plane, via the
  appropriate connected `/127`. Leaves install 8-way ECMP per remote leaf
  (one route via each spine); spines install one route per leaf.

This is the **minimum data plane** an SRv6 controller needs:

- Connected reachability so the outer-IPv6 destination of any encapsulated
  packet has a FIB entry.
- The full uA matrix so packets can hop spine ↔ leaf via uSID.
- `d000` on every leaf so any path landing there can decap into `Vrf-green`.

The controller layers on top:

- Tenant-prefix routes inside `Vrf-green` (host /64 reachability)
- SR policies / per-flow steering (e.g. plane affinity, congestion-aware
  scheduling)
- Yellow tenant routes (host-encap targets, plane selection)

## Tenant models in this lab

### Green (hybrid SRv6)

```
green-host00.eth2            p1-leaf00:Ethernet32 (Vrf-green)
   │ (encapsulated by host or upstream controller)            │
   │  outer dst: fc00:0001:2<L>:f<S>:d000::                   │
   ▼                                                          ▼
   ─────────►   fabric (uA hops)   ─────────►   uDT6 d000  ──►  Vrf-green
                                                              forwards to dst
                                                              host /64
```

Every leaf in every plane has `fc00:000<P>:d000::/48 uDT6 vrf Vrf-green`. The
controller picks any plane to deliver into, and the matching plane's leaf
decaps.

### Yellow (host-based SRv6)

```
yellow-host00.eth0  ─encap─►  fabric  ─►  egress p2-leaf07.Ethernet36  ─►
   ── uA ──►  yellow-host07.eth3 (plane 2 NIC)
                outer dst: fc00:0002:...:d001::
                seg6local End.DT6 table 0  →  decap, table-0 lookup
```

Each yellow host has 4 `seg6local` entries — one per plane — bound to the
respective plane NIC. The leaf is a pure transit hop; no `Vrf-yellow` exists.

## Reducing scale

If your host can't accommodate 96 SONiC nodes, edit the top of
`generate_fabric.py`:

```python
NUM_PLANES = 2           # 48 SONiC + 32 hosts, 320 veth pairs
NUM_SPINES = 4           # halve again per plane
NUM_LEAVES = 8
```

Hosts will reduce to the new `NUM_LEAVES` count. Re-run
`python3 generate_fabric.py` and redeploy.

## What this lab is *not*

- **Not a performance benchmark.** `docker-sonic-vs` runs a software ASIC; you
  will not see line-rate. The point is correctness of the SRv6 control plane
  and forwarding behavior.
- **Not a full controller.** No PCEP/BGP-LS/path-computation engine is
  included. The static SIDs and routes give you a substrate; programming
  end-to-end SR policies is left to whatever controller you wire up
  (e.g. `jalapeno`, an OpenConfig+gRPC actor, or hand-rolled `vtysh`/iproute2).
- **Not multi-cluster.** A single cluster lives at `fc00:0000::/30`. The
  scheme extends naturally — the next cluster would be `fc00:0004::/30`,
  etc. — but no WAN gear is modeled here.

## See also

- `../01-sonic-vs/README.md` — original 3×3 lab and a longer writeup of the
  three multi-tenancy models (network / hybrid / host based).


