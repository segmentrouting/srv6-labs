# BGP IPv4 over SRv6 (Containerlab)

XRd CLOS-style scenarios advertising IPv4 reachability over an SRv6-enabled fabric. Cisco IOS XR configs live under `config-6-node/` and `config-10-node/`.

**Topology files**

| File | Description |
|------|----------------|
| `topology-6-node.yaml` | Six XRd nodes in a small CLOS; `name: v4-over-srv6`. |
| `topology-10-node.yaml` | Super-spine and spine layer slice of a larger CLOS (`name: xrd-clos`). |
| `trex.yaml` | Linux hosts with TRex for traffic generation (separate lab name `trex`). |

**Deploy**

Load `ios-xr/xrd-control-plane:25.4.2`, then from this directory:

```bash
sudo containerlab deploy -t topology-6-node.yaml
```

Topologies use `prefix: ""` and IPv4-only management. Destroy with `sudo containerlab destroy -t <file>.yaml`.
