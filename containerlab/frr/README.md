### An 8-node SRv6 lab using FRR
Many thanks to Brian Linkletter as his blog post gave this lab a jumpstart: 
https://www.brianlinkletter.com/2021/05/use-containerlab-to-emulate-open-source-routers/

```
sudo containerlab deploy -t frr.yml
```

### FRR VRFs
VRFs must be added to FRR containers' underlying Linux per: https://docs.frrouting.org/en/latest/zebra.html#virtual-routing-and-forwarding

#### r1
```
ip link add blue type vrf table 10
ip link set dev blue up
ip link set dev eth3 master blue
ip addr add 2001:db8:3e8:7777::1/64 dev eth3
```

#### r6
```
ip link add blue type vrf table 10
ip link set dev blue up
ip link set dev eth3 master blue
ip addr add 2001:db8:3e8:8888::1/64 dev eth3
```
