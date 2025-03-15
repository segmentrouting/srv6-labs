## XRd eBGP SRv6 Lab

This lab is a simple 4 node lab with eBGP SRv6 enabled. The leaf nodes r02 and r03 each have an alpine container that is dual attached and simulating a host. The alpine images eth1 attaches to a router interface in the default/global vrf. The eth2 interface is attached to the routers' vrf blue. This allows for testing of SRv6 tunneling of both global and vrf traffic.

Topology:
```
  r00  r01--r99
   | \ / |
   | / \ |
  r02  r03
   |    |
  h00  h01
```

Note, in order to tunnel global ipv4 traffic over SRv6 we need to establish and ipv6 underlay that is entirely decoupled from ipv4. Hence, we have standard ipv6 eBGP peerings throughout the fabric, and we have introduced r99 which provides ipv4 route-reflector or route-server like service for global ipv4 prefixes.

### Deploy the topology

It is assumed containerlab is already installed. If not, please see: [readme](../README-clab.md)

1. Acquire an XRd control-plane image
Example: https://software.cisco.com/download/home/286331236/type/280805694/release/24.4.1

2. Load the image per [readme](../README-clab.md)
   
3. Launch the topology

```
sudo containerlab deploy -t topology.yml
```

4. Give it 60-90 seconds to boot, then ssh to routers (password is cisco123)
```
ssh cisco@clab-xrd-bgp-r00
ssh cisco@clab-xrd-bgp-r01
ssh cisco@clab-xrd-bgp-r02
ssh cisco@clab-xrd-bgp-r03
ssh cisco@clab-xrd-bgp-r99
```

5. XRd verification commands (example commands for r02)
```
show segment-routing srv6 sid
show bgp ipv6 unicast
show bgp ipv4 unicast
show bgp ipv4 unicast 3.3.3.0/24
show bgp vpnv4 unicast
show bgp vpnv4 unicast rd 10.0.0.3:0 101.0.0.0/24
```

6. Give the alpine host00 and host01 their IPs and routes
```
docker exec -it clab-xrd-bgp-host00 ip addr add 2.2.2.2/24 dev eth1
docker exec -it clab-xrd-bgp-host00 ip addr add 100.0.0.2/24 dev eth2
docker exec -it clab-xrd-bgp-host01 ip addr add 3.3.3.2/24 dev eth1
docker exec -it clab-xrd-bgp-host01 ip addr add 101.0.0.2/24 dev eth2   
docker exec -it clab-xrd-bgp-host00 ip route add 3.3.3.0/24 via 2.2.2.1 dev eth1
docker exec -it clab-xrd-bgp-host00 ip route add 101.0.0.0/24 via 100.0.0.1 dev eth2
docker exec -it clab-xrd-bgp-host01 ip route add 2.2.2.0/24 via 3.3.3.1 dev eth1
docker exec -it clab-xrd-bgp-host01 ip route add 100.0.0.0/24 via 101.0.0.1 dev eth2
```

7. ping tests from hosts to local gateways
```
docker exec -it clab-xrd-bgp-host00 ping 2.2.2.1 -c 4 -i .3
docker exec -it clab-xrd-bgp-host00 ping 100.0.0.1 -c 4 -i .3
docker exec -it clab-xrd-bgp-host01 ping 3.3.3.1 -c 4 -i .3
docker exec -it clab-xrd-bgp-host01 ping 101.0.0.1 -c 4 -i .3

8. End to end ping tests from host to host
```
docker exec -it clab-xrd-bgp-host00 ping 3.3.3.2 -c 4 -i .3
docker exec -it clab-xrd-bgp-host00 ping 101.0.0.2 -c 4 -i .3
docker exec -it clab-xrd-bgp-host01 ping 2.2.2.2 -c 4 -i .3
docker exec -it clab-xrd-bgp-host01 ping 100.0.0.2 -c 4 -i .3
```

9. Setup a tcpdump session and re-run host to host pings - the pings will appear on one of these interfaces:
```
docker exec -it clab-xrd-bgp-r00 tcpdump -ni Gi0-0-0-0
docker exec -it clab-xrd-bgp-r00 tcpdump -ni Gi0-0-0-1
docker exec -it clab-xrd-bgp-r01 tcpdump -ni Gi0-0-0-0
docker exec -it clab-xrd-bgp-r01 tcpdump -ni Gi0-0-0-1
```

Example:
```
$ docker exec -it clab-xrd-bgp-r01 tcpdump -ni Gi0-0-0-0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on Gi0-0-0-0, link-type EN10MB (Ethernet), capture size 262144 bytes
03:35:21.330441 IP6 fc00:0:1002::1 > fc00:0:1003:e001::: IP 2.2.2.2 > 3.3.3.2: ICMP echo request, id 157, seq 0, length 64
03:35:21.332586 IP6 fc00:0:1003::1 > fc00:0:1002:e001::: IP 3.3.3.2 > 2.2.2.2: ICMP echo reply, id 157, seq 0, length 64
03:35:21.630665 IP6 fc00:0:1002::1 > fc00:0:1003:e001::: IP 2.2.2.2 > 3.3.3.2: ICMP echo request, id 157, seq 1, length 64
03:35:21.632847 IP6 fc00:0:1003::1 > fc00:0:1002:e001::: IP 3.3.3.2 > 2.2.2.2: ICMP echo reply, id 157, seq 1, length 64
03:35:21.930811 IP6 fc00:0:1002::1 > fc00:0:1003:e001::: IP 2.2.2.2 > 3.3.3.2: ICMP echo request, id 157, seq 2, length 64
03:35:21.932806 IP6 fc00:0:1003::1 > fc00:0:1002:e001::: IP 3.3.3.2 > 2.2.2.2: ICMP echo reply, id 157, seq 2, length 64
03:35:22.230947 IP6 fc00:0:1002::1 > fc00:0:1003:e001::: IP 2.2.2.2 > 3.3.3.2: ICMP echo request, id 157, seq 3, length 64
03:35:22.233319 IP6 fc00:0:1003::1 > fc00:0:1002:e001::: IP 3.3.3.2 > 2.2.2.2: ICMP echo reply, id 157, seq 3, length 64
```
