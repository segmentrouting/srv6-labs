## SP Core and DC lab

Uses Containerlab to spin up different variants or portions of a common [topology](diagrams/sp-core-and-dc.png) running XRd instances (`ios-xr/xrd-control-plane:25.4.2`, `prefix: ""`, IPv4 management only).

* 30-node: a 30-node WAN or SP Core 
* 38-node: SP Core + BGP-CLOS DC
* 46-node: SP Core + BGP-CLOS DC + ISIS-CLOS DC

#### tcpdump on clab XRd interfaces:
```
sudo ip netns exec xrd-sp-xrd19 tcpdump -ni Gi0-0-0-0
```