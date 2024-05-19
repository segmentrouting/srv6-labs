## Static uSID

### Static uSID is not publicly available as of the creation of this document. This should be considered experimental and as reference only

#### Peterson graph topology is used

### End.DT46

1. add ips and static routes on linux client node1
#### ubuntu01
```
docker exec -it clab-trex-ubtrex01 ip addr add 10.101.1.2/24 dev eth1
docker exec -it clab-trex-ubtrex01 ip addr add fc00:0:101:1::2/64 dev eth1
docker exec -it clab-trex-ubtrex01 ip addr add 1.0.0.1/32 dev lo label lo:1
docker exec -it clab-trex-ubtrex01 ip addr add 1::1/128 dev lo label lo:1
docker exec -it clab-trex-ubtrex01 ip route add 9.0.0.9/32 via 10.101.1.1 dev eth1
docker exec -it clab-trex-ubtrex01 ip route add 9::9/128 via fc00:0:101:1::1 dev eth1
docker exec -it clab-trex-ubtrex01 ip route add 10.101.9.0/24 via 10.101.1.1 dev eth1
docker exec -it clab-trex-ubtrex01 ip route add fc00:0:101:9::/64 via fc00:0:101:1::1 dev eth1

docker exec -it clab-trex-ubtrex01 ip route
docker exec -it clab-trex-ubtrex01 ip a
```

2. configure xrd01
#### xrd01
```
segment-routing
  srv6
   static
   endpoint
    sid fc00:0:1:fe01:: behavior end-udt46
     allocation-context vrf default
     forwarding
 traffic-eng
  srv6
  segment-lists
   srv6
    sid-format usid-f3216
   segment-list xrd09-static01
    srv6
     index 10 sid fc00:0:9::
    !
   !
  !
  policy xrd09-static01
   srv6
    locator MAIN binding-sid dynamic behavior ub6-insert-reduced
   color 1001 end-point ipv6 fc00:0:9::1
   candidate-paths
    preference 100
     explicit segment-list xrd09-static01
    
router static
 address-family ipv4 unicast
  1.0.0.1/32 10.101.1.2
  9.0.0.9/32 segment-routing srv6 h-encaps-red fc00:0:9:fe01:: via-srv6-bsid fc00:0:1:e009:: permanent
 !
 address-family ipv6 unicast
  1::1/128 fc00:0:101:1::2
  9::9/128 segment-routing srv6 h-encaps-red fc00:0:9:fe01::

```

3. add ips and static routes to linux node9
#### ubuntu09
```
docker exec -it clab-trex-ubtrex09 ip addr add 10.101.9.2/24 dev eth1
docker exec -it clab-trex-ubtrex09 ip addr add fc00:0:101:9::2/64 dev eth1
docker exec -it clab-trex-ubtrex09 ip addr add 9.0.0.9/32 dev lo label lo:9
docker exec -it clab-trex-ubtrex09 ip addr add 9::9/128 dev lo label lo:9
docker exec -it clab-trex-ubtrex09 ip route add 1.0.0.1/32 via 10.101.9.1 dev eth1
docker exec -it clab-trex-ubtrex09 ip route add 1::1/128 via fc00:0:101:9::1 dev eth1
docker exec -it clab-trex-ubtrex09 ip route add 10.101.1.0/24 via 10.101.9.1 dev eth1
docker exec -it clab-trex-ubtrex09 ip route add fc00:0:101:1::/64 via fc00:0:101:9::1 dev eth1

docker exec -it clab-trex-ubtrex01 ip route
docker exec -it clab-trex-ubtrex01 ip a
```

4. configure xrd09
#### xrd09
```
segment-routing
  srv6
   static
   endpoint
    sid fc00:0:9:fe01:: behavior end-udt46
     allocation-context vrf default
     forwarding
 traffic-eng
  srv6
  segment-lists
   srv6
    sid-format usid-f3216
   segment-list xrd01-static01
    srv6
     index 10 sid fc00:0:1::
    !
   !
  !
  policy xrd01-static01
   srv6
    locator MAIN binding-sid dynamic behavior ub6-insert-reduced
   color 1001 end-point ipv6 fc00:0:1::1
   candidate-paths
    preference 100
     explicit segment-list xrd01-static01
     !
    !
   ! 
router static
 address-family ipv4 unicast
  1.0.0.1/32 segment-routing srv6 h-encaps-red fc00:0:1:fe01:: via-srv6-bsid fc00:0:9:e008:: permanent
  9.0.0.9/32 10.101.9.2
 !
 address-family ipv6 unicast
  1::1/128 segment-routing srv6 h-encaps-red fc00:0:1:fe01::
  9::9/128 fc00:0:101:9::2
```

### End.DX2

1. add ips and static routes to linux node2 (note, loopback routes optional)
#### ubuntu02
```
docker exec -it clab-trex-ubtrex02 ip addr add 10.101.2.1/24 dev eth1
docker exec -it clab-trex-ubtrex02 ip addr add fc00:0:101:2::1/64 dev eth1
docker exec -it clab-trex-ubtrex02 ip addr add 2.0.0.2/32 dev lo label lo:2
docker exec -it clab-trex-ubtrex02 ip addr add 2::2/128 dev lo label lo:2
docker exec -it clab-trex-ubtrex02 ip route add 10.0.0.10/32 via 10.101.2.2 dev eth1
docker exec -it clab-trex-ubtrex02 ip route add 10::10/128 via fc00:0:101:2::2 dev eth1

docker exec -it clab-trex-ubtrex02 ip route
docker exec -it clab-trex-ubtrex02 ip a
```

2. configure xrd02
#### xrd02
```
interface GigabitEthernet0/0/0/3
 no ipv4 address
 no ipv6 address fc00:0:101:2::2/64
 l2transport
!
segment-routing
 srv6
  static
   endpoint
    sid fc00:0:2:fe01:: behavior end-x-psp-usd              <-------- fails with "!!% Invalid argument: Invalid prefix"
     allocation-context nexthop GigabitEthernet0/0/0/3
l2vpn
 xconnect group static-usid
  p2p xrd02-xrd10-static01
   interface GigabitEthernet0/0/0/3
   neighbor segment-routing srv6 static target fc00:0:10:fe01:: source fc00:0:2:fe01::
  !
```

3. add ips and static routes to linux node10 (note, loopback routes optional)
#### ubuntu10
```
docker exec -it clab-trex-ubtrex10 ip addr add 10.101.2.2/24 dev eth1
docker exec -it clab-trex-ubtrex10 ip addr add fc00:0:101:2::2/64 dev eth1
docker exec -it clab-trex-ubtrex10 ip addr add 10.0.0.10/32 dev lo label lo:10
docker exec -it clab-trex-ubtrex10 ip addr add 10::10/128 dev lo label lo:10
docker exec -it clab-trex-ubtrex10 ip route add 2.0.0.2/32 via 10.101.2.1 dev eth1
docker exec -it clab-trex-ubtrex10 ip route add 2::2/128 via fc00:0:101:2::1 dev eth1

docker exec -it clab-trex-ubtrex10 ip route
docker exec -it clab-trex-ubtrex10 ip a
```

4. configure xrd10
#### xrd02
```
interface GigabitEthernet0/0/0/3
 no ipv4 address
 no ipv6 address fc00:0:101:10::2/64
 l2transport
!
segment-routing
 srv6
  static
   endpoint
    sid fc00:0:10:fe01:: behavior end-x-psp-usd              <-------- fails with "!!% Invalid argument: Invalid prefix"
     allocation-context nexthop GigabitEthernet0/0/0/3
l2vpn
 xconnect group static-usid
  p2p xrd10-xrd02-static01
   interface GigabitEthernet0/0/0/3
   neighbor segment-routing srv6 static target fc00:0:2:fe01:: source fc00:0:10:fe01::
  !
```