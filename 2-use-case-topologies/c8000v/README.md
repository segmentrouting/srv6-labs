# Containerlab Catalyst 8000v

This is a 7-node topology running Catalyst 8000v (IOS XE) on Containerlab. 

This demonstrates a Layer 3 IPv4 VPN (vpnv4) over an SRv6 enabled topology. This lab has been tested on Ubuntu 24.04.2, Containerlab 0.67, with IOS XE 17.12.04b

**Deploy:** from this directory, `sudo containerlab deploy -t srv6-7.clab.yml` (`name: srv6-7`, `prefix: ""`). The topology uses `vrnetlab/cisco_c8000v:17.12.04b`, not XRd.

Lab topology: 

<img alt="2 node" src="c8kv7node.png"> 
