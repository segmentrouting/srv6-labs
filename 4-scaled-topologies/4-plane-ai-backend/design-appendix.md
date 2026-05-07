# Design Appendix

A record of the design discussion behind this lab — the questions we asked, the
options we considered, and *why* we chose what we chose. Read this if you want
to understand the rationale, want to fork the lab and make different choices,
or are evaluating similar trade-offs in a real deployment.

The reference shape is the existing `01-sonic-vs/` lab (3×3 Clos, single
plane, BGP underlay, three tenancy models). This lab keeps the SRv6 substrate,
removes BGP, scales to 4 planes of 8×16, and drops the blue (network-based)
tenant.

---

## 1. uA SID function-bit encoding

When generating leaf-to-spine and spine-to-leaf uA SIDs, three encodings were
on the table:

| Option | Pattern | Example (leaf side, p2 toward spine03) |
|---|---|---|
| A | `f<P>0<S>` — encode plane in function | `fc00:0:f203::/48` |
| B | `f00<S>` per plane block | `fc00:0002:f003::/48` |
| C | `f000`/`f001`/... = "Ethernet0", "Ethernet4", ... (port-number-based) | `fc00:0:f000::/48` regardless of node role |

### Why we rejected Option C (port-number-based)

The motivation was tempting: every Ethernet0 has the same uA function, every
Ethernet4 has the same uA function — apparent simplicity.

The fatal problem is **loss of role information**. In a uniform Clos:

- On a *leaf*, Ethernet0 faces a spine.
- On a *spine*, Ethernet0 faces a leaf.

Under Option C, `f000` on a leaf means "go up to spine0", but `f000` on a
spine means "go down to leaf0". A controller building a path can no longer
read a SID list and tell *which tier* it's on without out-of-band node-role
context.

The current scheme deliberately separates the two:
- `f...` = "leaf-side uA" → packet is going up
- `e...` = "spine-side uA" → packet is going down

That makes a SID list self-describing. Worth keeping.

### Why we initially chose Option A, then moved to Option B

Option A (`f<P>0<S>`) made every uA SID globally unique by encoding the plane
in the function bits. That works, but it duplicates information: the locator
already tells you which node the packet is at, and once we moved to per-plane
uSID blocks (§2), the locator block already identifies the plane. So the plane
nibble in the function became redundant.

Final choice — **Option B**:

| Tier | uA function | Where it lives |
|---|---|---|
| Leaf → spine | `f00<S>` | inside that leaf's locator (= inside its plane block) |
| Spine → leaf | `e00<L>` | inside that spine's locator (= inside its plane block) |

A controller can still tell tier (`f` vs `e`), still tell which port (`<S>` /
`<L>`), and the plane comes from the block. No duplication.

---

## 2. uSID block: per-cluster vs per-plane

The defining design choice. We considered two layouts:

### Per-cluster block (rejected)

```
fc00:0000::/32     entire cluster (all 4 planes)
fc00:0:1<P><S>::/48   spine: plane in node bits
fc00:0:2<P><L>::/48   leaf:  plane in node bits
```

Pros:
- Single `/32` aggregate at the WAN.
- Tenant SIDs (e.g. `fc00:0:d000::/48`) are *flat* — same SID across all
  planes — which makes the "tenant-ID is just the last uSID" mental model
  trivially true.

Cons (the deciding ones):
- Plane identity is buried in node bits. To do per-plane policy / TE / fault
  isolation a controller has to mask out plane bits from the locator.
- Host routing is genuinely confusing: every host has four uplinks, each into
  a different plane, but every plane shares the same `/32`. A host route like
  `fc00:0::/32 nexthop via {eth1, eth2, eth3, eth4}` is a 4-way ECMP that's
  *almost never* what you want — the controller is supposed to pin flows to
  specific planes.

### Per-plane block (chosen)

```
fc00:0000::/30      cluster aggregate (4 planes)
fc00:000<P>::/32    plane <P>
fc00:000<P>:1<S>::/48   spine locator
fc00:000<P>:2<L>::/48   leaf locator
fc00:000<P>:f00<S>::/48 leaf-side uA
fc00:000<P>:e00<L>::/48 spine-side uA
fc00:000<P>:d000::/48   green tenant uDT6 (per plane, on leaves)
fc00:000<P>:d001::/48   yellow tenant uDT6 (per plane, on yellow hosts)
```

Pros:
- **Plane identity is a prefix.** A controller can match `fc00:000<P>::/32`
  and immediately know everything inside is plane-`<P>` traffic. Per-plane
  TE / isolation / advertisement / withdraw is a single longest-match.
- **Hosts get one route per plane.** No accidental ECMP across planes. The
  controller pins a flow to plane 2 simply by emitting an outer destination
  inside `fc00:0002::/32`; the host's plane-2 NIC route does the rest.
- Cluster aggregation at the WAN is still clean: one `/30` per cluster.
  Multi-cluster: `fc00:0000::/30` is cluster A, `fc00:0004::/30` is cluster B,
  etc. — `fc00::/16` covers up to 16 384 clusters.
- Each plane's uSID block is self-contained, so a path's full uSID list
  (`<plane>:<leaf>:<uA>:<tenant>`) lives entirely under one `/32`.

Cons:
- Tenant SIDs are no longer flat — `d000` exists per plane. For green this
  is naturally per-plane anyway (decap happens at the egress leaf, which is
  by definition plane-specific). For yellow it means each host installs
  **four `seg6local` entries**, one per plane NIC. That's the right model
  for host-based SRv6: the host kernel has to recognize "decap me" for
  *each plane the packet might arrive on*.
- Trivially more typing in addresses (8-hex-digit blocks instead of
  3-digit). Cosmetic.

### When you'd pick per-cluster instead

If you genuinely have a single fault/aggregation domain and *don't* want to
treat planes as independently steerable (e.g. a small lab where ECMP across
planes is fine), per-cluster is simpler. For anything modeled on a
hyperscale GPU backend, per-plane wins.

---

## 3. Tenant SIDs: flat vs per-plane

Closely related to §2, but worth calling out separately.

### Green (hybrid: leaf decap)

In the per-plane scheme, each leaf in plane `<P>` advertises
`fc00:000<P>:d000::/48 uDT6 vrf Vrf-green`. Because the leaf is plane-specific
*and* the SID is plane-specific, this is unambiguous: the controller picks an
egress leaf, the path's last uSID is `d000`, decap happens there.

### Yellow (host-based: host decap)

Yellow hosts are multi-homed across all four planes. A packet's outer
destination is determined by which plane the controller chose to deliver
through, so the destination's plane block could be any of the four. The host
must recognize all of them. We install four `seg6local` entries:

```
fc00:0000:d001::/48 dev eth1 encap seg6local action End.DT6 table 0
fc00:0001:d001::/48 dev eth2 encap seg6local action End.DT6 table 0
fc00:0002:d001::/48 dev eth3 encap seg6local action End.DT6 table 0
fc00:0003:d001::/48 dev eth4 encap seg6local action End.DT6 table 0
```

Each is bound to the plane's NIC. Linux matches on destination prefix; the
`dev` binding is a sanity guard (ensures the packet arrived on the plane it
claimed to come from).

### Considered alternative: reserve a flat tenant SID space

We briefly considered placing tenant SIDs in their own /32 (e.g.
`fc00:f::/32` reserved for "tenant-flat"). That would make `d000` truly
plane-independent again. We didn't take this path because:

1. It re-introduces the tier-leak problem in reverse: a SID list now
   straddles two address blocks, and "decap into green" is no longer
   colocated with the leaf locator that owns the decap.
2. Per-plane tenant SIDs reinforce the plane-isolation model: when plane 2
   is withdrawn at the WAN, *its* tenant SIDs go with it. With a flat tenant
   space the controller has to reason about partial reachability.

The price (4 seg6local entries per yellow host) is small and bounded.

---

## 4. Removing BGP entirely

The original 8×16 lab ran eBGP per leaf to each spine, with all forwarding
actually done by static SRv6 SIDs — BGP existed mainly to advertise loopbacks
and locators. Once a controller is in charge of installing all transit FIB,
BGP is dead weight.

Without BGP we still need *enough* FIB on each box for the outer-IPv6
destination of any SR-encapsulated packet to forward:

- **Spines:** need a route to every leaf locator in their plane. We install
  one static route per leaf via the connected `/127`.
- **Leaves:** need routes to every spine locator (single nexthop, the
  connected `/127`) *and* every other leaf locator in the plane. The latter
  go via all 8 spines as ECMP, since any spine can transit.

That's the full data-plane substrate. uA SIDs handle hop-by-hop steering on
top of that; uDT SIDs handle decap. The controller is responsible for
*tenant prefix* routes (host /64s in `Vrf-green`, host-side encap targets,
SR policies, plane affinity, etc.) — the static config is deliberately
minimal.

### What this gives up

- **No automatic loopback redistribution.** Add a node, you add static
  routes everywhere that needs to reach it. Fine for a generated lab; in
  production you'd want IS-IS-SRv6 or the controller itself programming
  these.
- **No fast convergence on link failure.** Static routes don't react. In
  production you'd lean on BFD-driven static, or use IS-IS for underlay
  reachability and keep the controller for SR policy.

### Why it's still useful

The lab's goal is to demonstrate the *SRv6 substrate* a controller would
build on. By removing BGP we make it explicit which entries are "data
plane" (in `frr.conf`) versus "controller-installed" (programmed at
runtime). It also means the lab boots without any IGP convergence wait —
once `vtysh -f` returns, forwarding is live.

---

## 5. Naming: `p<P>-{spine,leaf}<NN>` vs alternatives

We picked plane-as-prefix (`p2-leaf0a`) over plane-in-middle
(`leaf-p2-0a`) for one simple reason: it sorts well. `ls config/` groups all
of plane 0, then plane 1, etc. Alphabetic order matches operational
intuition.

Hosts stay color-prefixed (`green-host00`, `yellow-host00`) because hosts
are not plane-specific entities — each host straddles all four planes via
its NICs.

---

## 6. Fabric P2P address reuse

`2001:db8:fab:<S*16+L>::/127` is identical in every plane. Planes are
L2-isolated (different containerlab veth pairs, different physical ports
in production), so the addressing collision is harmless — a packet on
`p0-spine03 <-> p0-leaf07` never coexists with a packet on
`p2-spine03 <-> p2-leaf07`.

The alternative was making P2Ps globally unique by adding a plane nibble
(`2001:db8:fab<P>:<idx>::/127`). Burns more address space for no
operational benefit. We reuse.

---

## 7. Host port assignment on leaves

Each leaf has 32 dataplane ports (`Ethernet0..Ethernet124`, step 4). 8 are
used for spine uplinks (Ethernet0–28). That leaves 24 free for hosts. We
use only two:

- `Ethernet32` → `Vrf-green` → green-host on this leaf number
- `Ethernet36` → default VRF → yellow-host on this leaf number

**Why so few?** Because each color has only 16 hosts, one per leaf number,
and each host already connects to all 4 planes via its `eth1..eth4`. So per
leaf, in each plane, you have exactly one green host and one yellow host
attached. Adding more hosts per leaf would mean adding hosts of more colors
or oversubscribing — neither aligns with the "one host per leaf number,
multi-plane" model.

If you want a denser host count later, the obvious move is to add a third
color (e.g. blue) and bind it to `Ethernet40` in another VRF (or default).
The generator's `host_uplink_prefix()` and `write_topology_yaml()` hooks
make this a small change.

---

## 8. Scaling beyond one cluster

The `fc00:0000::/30` cluster aggregate sits inside `fc00::/16`. Multi-cluster
WAN deployment would look like:

```
fc00::/16              all SRv6 clusters globally
fc00:0000::/30         cluster A (planes 0–3 = fc00:0000..0003)
fc00:0004::/30         cluster B (planes 0–3 = fc00:0004..0007)
fc00:0008::/30         cluster C
...
```

A WAN-edge router would advertise `fc00:0000::/30` for cluster A, etc.
Inside the cluster, planes are still individually addressable for fine-grained
TE.

This lab models one cluster. The generator's plane-block prefix is
parameterized in `plane_block_prefix(plane)` — adding a `CLUSTER_ID` offset
is a one-line change if you want to spin up a second lab cluster on the same
host without address overlap.

---

## 9. What we'd reconsider in production

A list, not exhaustive:

- **IGP underlay.** IS-IS with SRv6 extensions (RFC 9352) for loopback /
  locator reachability and fast convergence on link failure. Keeps the
  static-SID/SR-policy split, drops the static IPv6 routes for transit.
- **Per-VRF BGP for tenant prefix learning** (e.g. EVPN/MP-BGP in
  Vrf-green) so that tenant prefixes don't need a controller round-trip
  for every host add. The controller still owns SR policies; BGP owns
  tenant reachability.
- **Hierarchical SIDs / binding SIDs** for path compression once the SID
  list grows. uSID compression already buys a lot, but at WAN scale you'll
  want explicit binding SIDs at cluster boundaries.
- **Telemetry and verification.** No mention here. In production,
  per-SID hit counters (FRR/Linux nftables-based) and SR-policy
  observability are essentials.
- **Failure modeling for plane outages.** The current lab has no mechanism
  to advertise/withdraw a plane on host-side. A real deployment would
  surface plane state to hosts (via BFD-on-uplink, or controller
  signaling) so green/yellow hosts can stop sending into a dead plane.
