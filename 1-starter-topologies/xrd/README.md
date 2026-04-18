# XRd starter topologies (Containerlab)

Small Cisco IOS XR XRd (control-plane) labs on point-to-point links. Configs live under `config/`.

**Topology files**

| File | Scenario |
|------|----------|
| `clab-4-node-xrd.yml` | Four routers in a diamond (each node sees three neighbors). |
| `clab-3-node-xrd-linux.yml` | Three XRd nodes (optional Linux/scapy attachments are commented). |
| `clab-2-node-vxlan-a.yml` / `clab-2-node-vxlan-b.yml` | Two-node pairs for VXLAN-style tests (separate labs). |

**Deploy**

Prerequisites: Containerlab, Docker, KVM, and an `ios-xr/xrd-control-plane:25.4.2` image loaded locally. See [../README-clab.md](../README-clab.md) for host setup.

```bash
cd 1-starter-topologies/xrd
sudo containerlab deploy -t clab-4-node-xrd.yml
```

Topologies set `prefix: ""`, so container names are `{lab-name}-{node-name}` (no `clab-` prefix). For the four-node lab (`name: 4-node`), routers appear as `4-node-xrd01`, …, `4-node-xrd04`.

**Destroy**

```bash
sudo containerlab destroy -t clab-4-node-xrd.yml
```
