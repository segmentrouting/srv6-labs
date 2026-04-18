# Host-based SRv6

Lab assets for SRv6 on the Linux host (Calico, VPP, etc.) plus a Containerlab slice under `clab/`.

**Containerlab (`clab/topology.yml`)**

Large XRd mesh (`name: host-based`, `prefix: ""`) for experiments attaching host networking. Image: `ios-xr/xrd-control-plane:25.4.2`. Configs are under `clab/xrd-config/`.

```bash
cd 2-use-case-topologies/host-based-srv6/clab
sudo containerlab deploy -t topology.yml
```

Use `containerlab destroy -t topology.yml` when finished. Other files in this folder document host-side VPP/Calico setup.
