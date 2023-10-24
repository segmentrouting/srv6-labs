### An 8-node SRv6 lab using FRR
Many thanks to Brian Linkletter as his blog post gave this lab a jumpstart: 
https://www.brianlinkletter.com/2021/05/use-containerlab-to-emulate-open-source-routers/

Instructions for loading docker images and installing containerlab can be found [HERE](../../1-starter-topologies/README-clab.md)

1. Once docker image(s) loaded and clab installed, deploy the frr.yml topology:

```
sudo containerlab deploy -t frr.yml
```

### Topology
![Topology](frr-srv6-topo.png)

r1, r2, and r3 are eBGP peers with one another
r4, r5, and r6 run ISIS and are in ASN 64512
r2 and r4 are eBGP peers
r3 and r5 are eBGP peers
r7 is a CE node with r1 as its PE
r8 is a CE node with r6 as its PE

### FRR VRFs
VRFs must be added to FRR containers' underlying Linux per: https://docs.frrouting.org/en/latest/zebra.html#virtual-routing-and-forwarding

2. Once the topology is up, run the frr-start.exp Expect script which will apply VRF settings and start FRR:

```
./frr-start.exp
```

#### r1 reference:
```
ip link add blue type vrf table 10
ip link set dev blue up
ip link set dev eth3 master blue
ip addr add 2001:db8:3e8:7777::1/64 dev eth3
sysctl net.ipv4.ip_forward=1
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.vrf.strict_mode=1
```

#### r6 reference:
```
ip link add blue type vrf table 10
ip link set dev blue up
ip link set dev eth3 master blue
ip addr add 2001:db8:3e8:8888::1/64 dev eth3
sysctl net.ipv4.ip_forward=1
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.vrf.strict_mode=1
```

#### all other nodes reference:
```
sysctl net.ipv4.ip_forward=1
sysctl net.ipv6.conf.all.forwarding=1
sysctl net.vrf.strict_mode=1
```

### Accessing FRR nodes:
1. Access FRR vtysh CLI:
```
docker exec -it clab-frr-frr-1 vtysh
```

2. Access FRR container linux shell:
```
docker exec -it clab-frr-frr-1 bash  
```

### Validate BGP ipv4 vpn

#### On r1
```
show bgp ipv4 vpn 10.8.1.0/24
or
show bgp vrf blue ipv4 uni 10.8.1.0/24
```
```
frr-1# show bgp ipv4 vpn 10.8.1.0/24
BGP routing table entry for 10.8.1.1:2:10.8.1.0/24, version 1
not allocated
Paths: (1 available, best #1)
  Advertised to non peer-group peers:
  2001:db8:3e8:70::1
  64701 64512
    0.0.0.0 from 2001:db8:3e8:70::1 (10.0.0.2)
      Origin incomplete, valid, external, best (First path received)
      Extended Community: RT:10.8.1.1:2
      Remote label: 917520
      Remote SID: fc00:0:6::
      Last update: Tue Oct 24 19:57:40 2023
```

#### on r6
```
show bgp ipv4 vpn 10.7.1.0/24
or
show bgp vrf blue ipv4 uni 10.7.1.0/24
```

```
frr-6# show bgp vrf blue ipv4 uni 10.7.1.0/24
BGP routing table entry for 10.7.1.0/24, version 3
Paths: (1 available, best #1, vrf blue)
  Advertised to non peer-group peers:
  10.8.1.2 2001:db8:3e8:8888::2
  Imported from 10.7.1.1:2:10.7.1.0/24
  64701 64700
    fc00:0:4::1 (metric 20) from :: (10.8.1.1) vrf default(0) announce-nh-self
      Origin incomplete, localpref 100, valid, sourced, local, best (First path received)
      Extended Community: RT:10.7.1.1:2
      Remote label: 917504
      Remote SID: fc00:0:1::
      Last update: Tue Oct 24 19:57:40 2023
```

### validate PE l3vpn routes in Linux
#### on r1
```
docker exec -it clab-frr-frr-1 ip route show vrf blue
```

```
cisco@topology-host:~$ docker exec -it clab-frr-frr-1 ip route show vrf blue
10.7.0.1 nhid 40 via 10.7.1.2 dev eth3 proto bgp metric 20 
10.7.1.0/24 dev eth3 proto kernel scope link src 10.7.1.1 
10.8.1.0/24 nhid 52  encap seg6 mode encap segs 1 [ fc00:0:6:e001:: ] via inet6 2001:db8:3e8:70::1 dev eth1 proto bgp metric 20 
```

### tcpdump
1. Run a ping from CE frr-7

```
docker exec -it  clab-frr-frr-7 ping -i .3 10.8.1.1
```

2. Enter container netns to run tcpdump
```
sudo ip netns exec clab-frr-frr-1 tcpdump -ni eth2
```

*Note* tcpdump output may not display immediately. ctrl-c will stop the tcpdump and should show the output:
```
isco@topology-host:~$ sudo ip netns exec clab-frr-frr-1 tcpdump -ni eth1
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C20:14:37.509899 IP6 fe80::a8c1:abff:fe8d:e692 > ff02::1: ICMP6, router advertisement, length 56
20:14:37.672658 IP6 fc00:0:1::1 > fc00:0:6:e001::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:6:e001::) IP 10.7.1.2 > 10.8.1.1: ICMP echo request, id 24, seq 200, length 64
20:14:37.672743 IP6 fc00:0:6::1 > fc00:0:1:e000::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:e000::) IP 10.8.1.1 > 10.7.1.2: ICMP echo reply, id 24, seq 200, length 64
20:14:37.992626 IP6 fc00:0:1::1 > fc00:0:6:e001::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:6:e001::) IP 10.7.1.2 > 10.8.1.1: ICMP echo request, id 24, seq 201, length 64
20:14:37.992693 IP6 fc00:0:6::1 > fc00:0:1:e000::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:e000::) IP 10.8.1.1 > 10.7.1.2: ICMP echo reply, id 24, seq 201, length 64
20:14:38.312621 IP6 fc00:0:1::1 > fc00:0:6:e001::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:6:e001::) IP 10.7.1.2 > 10.8.1.1: ICMP echo request, id 24, seq 202, length 64
20:14:38.312704 IP6 fc00:0:6::1 > fc00:0:1:e000::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:e000::) IP 10.8.1.1 > 10.7.1.2: ICMP echo reply, id 24, seq 202, length 64
20:14:38.509932 IP6 fe80::a8c1:abff:fe8d:e692 > ff02::1: ICMP6, router advertisement, length 56
20:14:38.632649 IP6 fc00:0:1::1 > fc00:0:6:e001::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:6:e001::) IP 10.7.1.2 > 10.8.1.1: ICMP echo request, id 24, seq 203, length 64
20:14:38.632729 IP6 fc00:0:6::1 > fc00:0:1:e000::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:e000::) IP 10.8.1.1 > 10.7.1.2: ICMP echo reply, id 24, seq 203, length 64
20:14:38.952724 IP6 fc00:0:1::1 > fc00:0:6:e001::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:6:e001::) IP 10.7.1.2 > 10.8.1.1: ICMP echo request, id 24, seq 204, length 64
20:14:38.952841 IP6 fc00:0:6::1 > fc00:0:1:e000::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:e000::) IP 10.8.1.1 > 10.7.1.2: ICMP echo reply, id 24, seq 204, length 64

12 packets captured
12 packets received by filter
0 packets dropped by kernel
```