#!/usr/bin/env python3
"""
Generate a 4-plane x (8-spine x 16-leaf) SRv6 CLOS for docker-sonic-vs + Containerlab.

Design summary
--------------
* 4 planes (p0..p3), each plane is a fully independent 8x16 Clos.
  - Spine nodes: p<P>-spine<S>      P in 0..3, S in 0..7
  - Leaf  nodes: p<P>-leaf<L>       P in 0..3, L in 0..15 (hex)
* 16 green hosts + 16 yellow hosts. Each host has 4 uplinks (eth1..eth4),
  one to the same-numbered leaf in each plane.
    green-host<NN>:eth(P+1) -> p<P>-leaf<NN>:Ethernet32   (Vrf-green on leaf)
    yellow-host<NN>:eth(P+1) -> p<P>-leaf<NN>:Ethernet36  (default VRF on leaf)

Addressing — per-plane uSID blocks
----------------------------------
The cluster is a /30 of /32 plane blocks under fc00::/16:

    cluster aggregate :  fc00:0000::/30   (covers all 4 planes)
    plane <P> block   :  fc00:000<P>::/32

Locators (unique per node, fabric-wide):
    spine:  fc00:000<P>:1<S>::/48     loopback fc00:000<P>:1<S>::1
    leaf :  fc00:000<P>:2<L>::/48     loopback fc00:000<P>:2<L>::1

Fabric P2P (reused identically per plane; planes are L2-isolated):
    2001:db8:fab:<spine*16+leaf>::/127     spine ::0  /  leaf ::1

Host uplinks (unique per (host,plane)):
    green-host<NN> eth(P+1)  : 2001:db8:bbbb:<P><NN>::2/64  gw ::1
    yellow-host<NN> eth(P+1) : 2001:db8:cccc:<P><NN>::2/64  gw ::1

uSID function-bits namespace (per plane block)
----------------------------------------------
* f00<S>    : leaf-side uA toward spine S in this plane    (used on leaves)
* e00<L>    : spine-side uA toward leaf L in this plane    (used on spines)
* d000      : tenant-ID uDT6 -> Vrf-green                  (every leaf)
* d001      : tenant-ID uDT6 -> table 0                    (every yellow host,
                                                            installed once per
                                                            plane on its NIC)

Plane is encoded in the locator block; function-bits no longer need to carry
plane. A controller-generated path like
    fc00:0002:20a:f203:d000::
unambiguously says: "plane 2, deliver to leaf0a, egress toward spine03 (uA),
then decap into Vrf-green at the next hop". Each plane is a self-contained /32
which simplifies WAN advertisement, plane isolation, and fault domain reasoning
(see Microsoft Fairwater AI fabric for a comparable hyperscale shape).

Controller-driven (no BGP / no IGP)
-----------------------------------
frr.conf carries no router bgp. Instead each node has:
  - segment-routing srv6 locator (uN) and the static uA / uDT SIDs above
  - static IPv6 routes for every remote locator in its own plane (via the
    correct connected /127) so packets actually have a FIB entry to forward
    on. This is the minimum data plane on which the controller programs end-
    to-end SR policies and tenant routes.

Run:  python3 generate_fabric.py
"""
from __future__ import annotations

import json
from pathlib import Path

NUM_PLANES = 4
NUM_SPINES = 8
NUM_LEAVES = 16

TOPOLOGY_NAME = "sonic-docker-4p-8x16"
SONIC_IMAGE = "docker-sonic-vs:latest"
HOST_IMAGE = "iejalapeno/alpine-srv6:1.0"

SCRIPT_DIR = Path(__file__).resolve().parent
CONFIG_DIR = SCRIPT_DIR / "config"
REF_LEAF_CONFIG = SCRIPT_DIR.parent / "01-sonic-vs" / "config" / "leaf00" / "config_db.json"

# Management subnet (172.20.18.0/24): plenty of room for 96 switches + 32 hosts.
MGMT_SUBNET_BASE = "172.20.18"
SPINE_MGMT_START = 10   # .10 .. .41   (4 planes * 8 spines = 32)
LEAF_MGMT_START = 50    # .50 .. .113  (4 planes * 16 leaves = 64)
HOST_MGMT_START = 200   # .200 .. .231 (16 green + 16 yellow = 32)

GREEN_VRF = "Vrf-green"

# Function-bits in d-space for tenant-ID uDT6 SIDs. Tenant SIDs live INSIDE
# each plane's /32 (since the locator block already identifies the plane).
# Green is decapped at the egress leaf; yellow is decapped at the destination
# host (which therefore needs one seg6local per plane on its respective NIC).
TENANT_GREEN_SID_FUNC = 0xd000
TENANT_YELLOW_SID_FUNC = 0xd001


def plane_block_prefix(plane: int) -> str:
    """fc00:000<P> — the /32 high bits of plane <P>."""
    return f"fc00:000{plane:x}"


def plane_aggregate(plane: int) -> str:
    return f"{plane_block_prefix(plane)}::/32"


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

def hex1(n: int) -> str:
    return f"{n:x}"


def link_idx(spine: int, leaf: int) -> int:
    return spine * NUM_LEAVES + leaf


def p2p_prefix(spine: int, leaf: int) -> str:
    """Reused identically per plane."""
    return f"2001:db8:fab:{link_idx(spine, leaf):04x}"


def spine_name(plane: int, spine: int) -> str:
    return f"p{plane}-spine{spine:02d}"


def leaf_name(plane: int, leaf: int) -> str:
    return f"p{plane}-leaf{leaf:02d}"


def spine_locator(plane: int, spine: int) -> str:
    return f"{plane_block_prefix(plane)}:1{hex1(spine)}::/48"


def spine_loopback(plane: int, spine: int) -> str:
    return f"{plane_block_prefix(plane)}:1{hex1(spine)}::1"


def spine_loopback_v4(plane: int, spine: int) -> str:
    return f"10.0.{plane}.{spine + 1}"


def leaf_locator(plane: int, leaf: int) -> str:
    return f"{plane_block_prefix(plane)}:2{hex1(leaf)}::/48"


def leaf_loopback(plane: int, leaf: int) -> str:
    return f"{plane_block_prefix(plane)}:2{hex1(leaf)}::1"


def leaf_loopback_v4(plane: int, leaf: int) -> str:
    return f"10.1.{plane}.{leaf + 1}"


def leaf_uplink_eth(spine: int) -> str:
    """On a leaf, uplink toward spine S is Ethernet(S*4)."""
    return f"Ethernet{spine * 4}"


def spine_downlink_eth(leaf: int) -> str:
    """On a spine, downlink toward leaf L is Ethernet(L*4)."""
    return f"Ethernet{leaf * 4}"


def leaf_ua_sid(plane: int, spine: int) -> str:
    """f00<S>: leaf-side uA SID toward spine S, inside plane <P>'s block."""
    return f"{plane_block_prefix(plane)}:f00{hex1(spine)}::/48"


def spine_ua_sid(plane: int, leaf: int) -> str:
    """e00<L>: spine-side uA SID toward leaf L, inside plane <P>'s block."""
    return f"{plane_block_prefix(plane)}:e00{hex1(leaf)}::/48"


def leaf_host_ua_sid(plane: int, eth_port_num: int) -> str:
    """e<NNN>: leaf-side uA SID toward whatever's attached on Ethernet<eth_port_num>.

    Same e-space and same numbering rule as spine→leaf: function value is the
    NIC ordinal (port_number / 4), so Ethernet0=e000, Ethernet4=e001,
    Ethernet32=e008, Ethernet36=e009, Ethernet40=e00a, etc.

    This matches the spine pattern exactly (on a spine, leaf L is on
    Ethernet<L*4>, which is NIC ordinal L = e00<L>) so a single rule applies
    fabric-wide: 'e<ordinal> = step down out the port at this NIC ordinal'.
    """
    nic_ordinal = eth_port_num // 4
    return f"{plane_block_prefix(plane)}:e{nic_ordinal:03x}::/48"


def green_udt_sid(plane: int) -> str:
    """uDT6 -> Vrf-green for plane <P>."""
    return f"{plane_block_prefix(plane)}:{TENANT_GREEN_SID_FUNC:04x}::/48"


def yellow_udt_sid(plane: int) -> str:
    """uDT6 -> table 0 for plane <P> (installed on yellow hosts)."""
    return f"{plane_block_prefix(plane)}:{TENANT_YELLOW_SID_FUNC:04x}::/48"


def host_uplink_prefix(color: str, plane: int, host: int) -> str:
    """Per-(host,plane) /64. Color is 'bbbb' (green) or 'cccc' (yellow)."""
    base = "bbbb" if color == "green" else "cccc"
    return f"2001:db8:{base}:{hex1(plane)}{host:02x}"


def load_port_template() -> dict:
    if REF_LEAF_CONFIG.is_file():
        with open(REF_LEAF_CONFIG, encoding="utf-8") as f:
            return json.load(f)["PORT"]
    raise SystemExit(f"Missing reference PORT template: {REF_LEAF_CONFIG}")


# ---------------------------------------------------------------------------
# config_db.json
# ---------------------------------------------------------------------------

def write_leaf_config_db(plane: int, leaf: int, port_table: dict) -> None:
    hostname = leaf_name(plane, leaf)
    rid_v4 = leaf_loopback_v4(plane, leaf)
    lo6 = leaf_loopback(plane, leaf)

    iface: dict = {
        "Loopback0": {},
        f"Loopback0|{rid_v4}/32": {},
        f"Loopback0|{lo6}/128": {},
    }
    # Uplinks toward all 8 spines (in this plane).
    for s in range(NUM_SPINES):
        eth = leaf_uplink_eth(s)
        pfx = p2p_prefix(s, leaf)
        iface[eth] = {}
        iface[f"{eth}|{pfx}::1/127"] = {}

    # Host-facing ports.
    # Ethernet32 -> green host (in Vrf-green)
    # Ethernet36 -> yellow host (default VRF; host-based SRv6 model)
    green_pfx = host_uplink_prefix("green", plane, leaf)
    yellow_pfx = host_uplink_prefix("yellow", plane, leaf)
    iface["Ethernet32"] = {"vrf_name": GREEN_VRF}
    iface[f"Ethernet32|{green_pfx}::1/64"] = {}
    iface["Ethernet36"] = {}
    iface[f"Ethernet36|{yellow_pfx}::1/64"] = {}

    mac = f"02:42:ac:12:{plane:x}{leaf:x}:01"

    cfg = {
        "DEVICE_METADATA": {
            "localhost": {
                "mac": mac,
                "switch_type": "switch",
                "buffer_model": "traditional",
                "hwsku": "Force10-S6000",
                "hostname": hostname,
                "docker_routing_config_mode": "split",
            }
        },
        "LOOPBACK_INTERFACE": {
            "Loopback0": {},
            f"Loopback0|{rid_v4}/32": {},
            f"Loopback0|{lo6}/128": {},
        },
        "VRF": {GREEN_VRF: {}},
        "INTERFACE": iface,
        "PORT": port_table,
    }

    out = CONFIG_DIR / hostname / "config_db.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w", encoding="utf-8") as f:
        json.dump(cfg, f, indent=4)
        f.write("\n")


def write_spine_config_db(plane: int, spine: int, port_table: dict) -> None:
    hostname = spine_name(plane, spine)
    rid_v4 = spine_loopback_v4(plane, spine)
    lo6 = spine_loopback(plane, spine)

    iface: dict = {
        "Loopback0": {},
        f"Loopback0|{rid_v4}/32": {},
        f"Loopback0|{lo6}/128": {},
    }
    for leaf in range(NUM_LEAVES):
        eth = spine_downlink_eth(leaf)
        pfx = p2p_prefix(spine, leaf)
        iface[eth] = {}
        iface[f"{eth}|{pfx}::0/127"] = {}

    mac = f"02:42:ac:11:{plane:x}{spine:x}:01"

    cfg = {
        "DEVICE_METADATA": {
            "localhost": {
                "mac": mac,
                "switch_type": "switch",
                "buffer_model": "traditional",
                "hwsku": "Force10-S6000",
                "hostname": hostname,
                "docker_routing_config_mode": "split",
            }
        },
        "LOOPBACK_INTERFACE": {
            "Loopback0": {},
            f"Loopback0|{rid_v4}/32": {},
            f"Loopback0|{lo6}/128": {},
        },
        "INTERFACE": iface,
        "PORT": port_table,
    }

    out = CONFIG_DIR / hostname / "config_db.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    with open(out, "w", encoding="utf-8") as f:
        json.dump(cfg, f, indent=4)
        f.write("\n")


# ---------------------------------------------------------------------------
# frr.conf  (no BGP, no IGP — pure SRv6 + connected/locator statics)
# ---------------------------------------------------------------------------

SRV6_LOCATOR_BLOCK = """ srv6
  encapsulation
   source-address {lo6}
  exit
  locators
   locator MAIN
    prefix {loc} block-len 32 node-len 16 func-bits 16
    behavior usid
   exit
   !
  exit
  !
  formats
   format usid-f3216
   exit
   !
   format uncompressed-f4024
   exit
   !
  exit
  !
 exit
"""


def write_leaf_frr(plane: int, leaf: int) -> None:
    hostname = leaf_name(plane, leaf)
    lo6 = leaf_loopback(plane, leaf)
    loc = leaf_locator(plane, leaf)

    # Static uA toward each spine in this plane.
    sid_lines = [f"   sid {loc} locator MAIN behavior uN"]
    for s in range(NUM_SPINES):
        eth = leaf_uplink_eth(s)
        nh = f"{p2p_prefix(s, leaf)}::0"
        sid_lines.append(
            f"   sid {leaf_ua_sid(plane, s)} locator MAIN behavior uA interface {eth} nexthop {nh}"
        )
    # Tenant-ID uDT6 for green, inside this plane's /32 block.
    sid_lines.append(
        f"   sid {green_udt_sid(plane)} locator MAIN behavior uDT6 vrf {GREEN_VRF}"
    )
    # Host-facing uA toward the yellow host on Ethernet36. Yellow uses the
    # host-based SRv6 model (host decaps via seg6local), so the egress leaf
    # needs a uA-terminated forward to the host's NIC.
    #
    # Note: no symmetric e032 for green. Green's Ethernet32 sits in Vrf-green,
    # but FRR's static-sids uA programs the seg6local in the default
    # routing namespace and the next-hop must resolve there. Green doesn't
    # need it anyway — the d000 uDT6 above decaps into Vrf-green and the
    # connected /64 lookup hands the packet to the host.
    yellow_host_nh = f"{host_uplink_prefix('yellow', plane, leaf)}::2"
    sid_lines.append(
        f"   sid {leaf_host_ua_sid(plane, 36)} locator MAIN behavior uA "
        f"interface Ethernet36 nexthop {yellow_host_nh}"
    )
    static_block = "\n".join(sid_lines)

    # Static IPv6 routes for every spine locator in this plane (one per spine,
    # via that spine's directly-connected /127). This gives the data plane
    # enough FIB to forward SR-policy packets without an IGP.
    static_routes = []
    for s in range(NUM_SPINES):
        nh = f"{p2p_prefix(s, leaf)}::0"
        static_routes.append(f"ipv6 route {spine_locator(plane, s)} {nh}")
    # Static routes for every other leaf locator in this plane: each via all
    # 8 spines (ECMP) so any spine can forward toward that remote leaf.
    for other in range(NUM_LEAVES):
        if other == leaf:
            continue
        for s in range(NUM_SPINES):
            nh = f"{p2p_prefix(s, leaf)}::0"
            static_routes.append(f"ipv6 route {leaf_locator(plane, other)} {nh}")
    static_routes_block = "\n".join(static_routes)

    txt = f"""hostname {hostname}
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
vrf {GREEN_VRF}
 ip nht resolve-via-default
 ipv6 nht resolve-via-default
exit-vrf
!
vrf vrfdefault
 ip nht resolve-via-default
 ipv6 nht resolve-via-default
exit-vrf
!
ip nht resolve-via-default
ipv6 nht resolve-via-default
!
{static_routes_block}
!
segment-routing
 srv6
  static-sids
{static_block}
  exit
  !
 exit
 !
{SRV6_LOCATOR_BLOCK.format(lo6=lo6, loc=loc)}!
exit
!
end
"""
    out = CONFIG_DIR / hostname / "frr.conf"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(txt, encoding="utf-8")


def write_spine_frr(plane: int, spine: int) -> None:
    hostname = spine_name(plane, spine)
    lo6 = spine_loopback(plane, spine)
    loc = spine_locator(plane, spine)

    sid_lines = [f"   sid {loc} locator MAIN behavior uN"]
    for leaf in range(NUM_LEAVES):
        eth = spine_downlink_eth(leaf)
        nh = f"{p2p_prefix(spine, leaf)}::1"
        sid_lines.append(
            f"   sid {spine_ua_sid(plane, leaf)} locator MAIN behavior uA interface {eth} nexthop {nh}"
        )
    static_block = "\n".join(sid_lines)

    # Spines need FIB entries to deliver to any leaf locator in their plane.
    static_routes = []
    for leaf in range(NUM_LEAVES):
        nh = f"{p2p_prefix(spine, leaf)}::1"
        static_routes.append(f"ipv6 route {leaf_locator(plane, leaf)} {nh}")
    static_routes_block = "\n".join(static_routes)

    txt = f"""hostname {hostname}
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
ip nht resolve-via-default
ipv6 nht resolve-via-default
!
{static_routes_block}
!
segment-routing
 srv6
  static-sids
{static_block}
  exit
  !
 exit
 !
{SRV6_LOCATOR_BLOCK.format(lo6=lo6, loc=loc)}!
exit
!
end
"""
    out = CONFIG_DIR / hostname / "frr.conf"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(txt, encoding="utf-8")


# ---------------------------------------------------------------------------
# topology.clab.yaml
# ---------------------------------------------------------------------------

def write_topology_yaml(path: Path) -> None:
    L = []
    L.append(f"name: {TOPOLOGY_NAME}")
    L.append('prefix: ""')
    L.append("")
    L.append("mgmt:")
    L.append("  network: mgt")
    L.append(f"  ipv4-subnet: {MGMT_SUBNET_BASE}.0/24")
    L.append("")
    L.append("topology:")
    L.append("  nodes:")
    L.append("")

    # Spines
    mgmt = SPINE_MGMT_START
    for p in range(NUM_PLANES):
        for s in range(NUM_SPINES):
            L.append(f"    {spine_name(p, s)}:")
            L.append("      kind: linux")
            L.append(f"      image: {SONIC_IMAGE}")
            L.append(f"      mgmt-ipv4: {MGMT_SUBNET_BASE}.{mgmt}")
            L.append("")
            mgmt += 1

    # Leaves
    mgmt = LEAF_MGMT_START
    for p in range(NUM_PLANES):
        for leaf in range(NUM_LEAVES):
            L.append(f"    {leaf_name(p, leaf)}:")
            L.append("      kind: linux")
            L.append(f"      image: {SONIC_IMAGE}")
            L.append(f"      mgmt-ipv4: {MGMT_SUBNET_BASE}.{mgmt}")
            L.append("")
            mgmt += 1

    # Hosts: 16 green + 16 yellow, each with 4 uplinks.
    mgmt = HOST_MGMT_START
    for color in ("green", "yellow"):
        for n in range(NUM_LEAVES):
            name = f"{color}-host{n:02d}"
            L.append(f"    {name}:")
            L.append("      kind: linux")
            L.append(f"      image: {HOST_IMAGE}")
            L.append(f"      mgmt-ipv4: {MGMT_SUBNET_BASE}.{mgmt}")
            L.append("      exec:")
            for p in range(NUM_PLANES):
                eth = f"eth{p + 1}"
                pfx = host_uplink_prefix(color, p, n)
                L.append(f'        - "ip addr add {pfx}::2/64 dev {eth}"')
            # One reachability route per plane: each plane's /32 uSID block
            # is reached via that plane's NIC. Unambiguous (no accidental
            # cross-plane ECMP); the controller picks plane-specific
            # destinations like fc00:0002:... to pin a flow to plane 2.
            base = "bbbb" if color == "green" else "cccc"
            for p in range(NUM_PLANES):
                eth = f"eth{p + 1}"
                gw = f"{host_uplink_prefix(color, p, n)}::1"
                L.append(
                    f'        - "ip -6 route add {plane_aggregate(p)} via {gw} dev {eth}"'
                )
            # Tenant prefix /48 reachable via plane 0 by default; controller
            # may override per-flow. Same pattern as 01-sonic-vs.
            tenant_prefix = f"2001:db8:{base}::/48"
            gw0 = f"{host_uplink_prefix(color, 0, n)}::1"
            L.append(
                f'        - "ip -6 route add {tenant_prefix} via {gw0} dev eth1"'
            )
            # Yellow hosts run host-based SRv6: install a uDT6 seg6local on
            # EACH plane's NIC, since the destination address inside the
            # encapsulated outer IPv6 carries the plane's block prefix.
            if color == "yellow":
                for p in range(NUM_PLANES):
                    eth = f"eth{p + 1}"
                    L.append(
                        f'        - "ip -6 route add {yellow_udt_sid(p)} '
                        f'dev {eth} encap seg6local action End.DT6 table 0"'
                    )
            L.append("")
            mgmt += 1

    L.append("  links:")
    L.append("")

    # Fabric: 4 planes * 8 spines * 16 leaves = 512 links.
    # Leaf eth(s+1) <-> spine eth(leaf+1) (eth0 is mgmt; eth1 is first data nic).
    for p in range(NUM_PLANES):
        for s in range(NUM_SPINES):
            for leaf in range(NUM_LEAVES):
                L.append(
                    f'    - endpoints: ["{leaf_name(p, leaf)}:eth{s + 1}", '
                    f'"{spine_name(p, s)}:eth{leaf + 1}"]'
                )

    # Host links: each host has 4 uplinks, one per plane.
    # Leaf side uses eth9 (Ethernet32, green) and eth10 (Ethernet36, yellow).
    # i.e. data NIC index = (port_number/4) + 1.  Ethernet32 -> eth9, Ethernet36 -> eth10.
    for p in range(NUM_PLANES):
        for n in range(NUM_LEAVES):
            L.append(
                f'    - endpoints: ["{leaf_name(p, n)}:eth9", '
                f'"green-host{n:02d}:eth{p + 1}"]'
            )
            L.append(
                f'    - endpoints: ["{leaf_name(p, n)}:eth10", '
                f'"yellow-host{n:02d}:eth{p + 1}"]'
            )

    path.write_text("\n".join(L) + "\n", encoding="utf-8")


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main() -> None:
    port_table = load_port_template()
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)

    for p in range(NUM_PLANES):
        for s in range(NUM_SPINES):
            write_spine_config_db(p, s, port_table)
            write_spine_frr(p, s)
        for leaf in range(NUM_LEAVES):
            write_leaf_config_db(p, leaf, port_table)
            write_leaf_frr(p, leaf)

    topo_path = SCRIPT_DIR / "topology.clab.yaml"
    write_topology_yaml(topo_path)

    n_spines = NUM_PLANES * NUM_SPINES
    n_leaves = NUM_PLANES * NUM_LEAVES
    n_hosts = 2 * NUM_LEAVES
    n_fabric_links = NUM_PLANES * NUM_SPINES * NUM_LEAVES
    n_host_links = NUM_PLANES * NUM_LEAVES * 2  # green+yellow per leaf per plane

    print(f"Wrote {topo_path}")
    print(f"Wrote SONiC configs under {CONFIG_DIR}/")
    print(
        f"  {n_spines} spines, {n_leaves} leaves, {n_hosts} hosts, "
        f"{n_fabric_links} fabric links + {n_host_links} host links"
    )
    print("Deploy lab: containerlab deploy -t topology.clab.yaml")
    print("Push configs: ./config.sh all")


if __name__ == "__main__":
    main()
