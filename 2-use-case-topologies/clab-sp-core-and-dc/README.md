## SP Core and DC lab

Uses Containerlab to spin up different variants or portions of a common [topology](diagrams/sp-core-and-dc.png) running XRd instances.

30-node: a 30-node WAN or SP Core 
38-node: SP Core + BGP-CLOS DC
46-node: SP Core + BGP-CLOS DC + ISIS-CLOS DC

#### tcpdump on clab XRd interfaces:
sudo ip netns exec  clab-xrd-30-node-xrd19 tcpdump -ni Gi0-0-0-0