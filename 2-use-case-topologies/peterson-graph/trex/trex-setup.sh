#!/bin/sh

# IP addresses and routes

## ubuntu trex 01
#docker exec -it clab-trex-ubtrex01 sysctl -p
docker exec -it clab-trex-ubtrex01 systemctl start trex
docker exec -it clab-trex-ubtrex01 ip addr add 10.101.1.2/24 dev eth1
docker exec -it clab-trex-ubtrex01 ip addr add fc00:0:101:1::101/64 dev eth1
docker exec -it clab-trex-ubtrex01 ip route add 10.0.0.0/8 via 10.101.1.1 dev eth1
docker exec -it clab-trex-ubtrex01 ip -6 route add fc00:0000::/32 via fc00:0:101:1::1 dev eth1

## ubuntu trex 02
#docker exec -it clab-trex-ubtrex02 sysctl -p
docker exec -it clab-trex-ubtrex02 systemctl start trex
docker exec -it clab-trex-ubtrex02 ip addr add 10.101.2.2/24 dev eth1
docker exec -it clab-trex-ubtrex02 ip addr add fc00:0:101:2::102/64 dev eth1
docker exec -it clab-trex-ubtrex02 ip route add 10.0.0.0/8 via 10.101.2.1 dev eth1
docker exec -it clab-trex-ubtrex02 ip -6 route add fc00:0000::/32 via fc00:0:101:2::1 dev eth1

## ubuntu trex 03
#docker exec -it clab-trex-ubtrex03 sysctl -p
docker exec -it clab-trex-ubtrex03 systemctl start trex
docker exec -it clab-trex-ubtrex03 ip addr add 10.101.3.2/24 dev eth1
docker exec -it clab-trex-ubtrex03 ip addr add fc00:0:101:3::103/64 dev eth1
docker exec -it clab-trex-ubtrex03 ip route add 10.0.0.0/8 via 10.101.3.1 dev eth1
docker exec -it clab-trex-ubtrex03 ip -6 route add fc00:0000::/32 via fc00:0:101:3::1 dev eth1

## ubuntu trex 04
#docker exec -it clab-trex-ubtrex04 sysctl -p
docker exec -it clab-trex-ubtrex04 systemctl start trex
docker exec -it clab-trex-ubtrex04 ip addr add 10.101.4.2/24 dev eth1
docker exec -it clab-trex-ubtrex04 ip addr add fc00:0:101:4::104/64 dev eth1
docker exec -it clab-trex-ubtrex04 ip route add 10.0.0.0/8 via 10.101.4.1 dev eth1
docker exec -it clab-trex-ubtrex04 ip -6 route add fc00:0000::/32 via fc00:0:101:4::1 dev eth1

## ubuntu trex 05
#docker exec -it clab-trex-ubtrex05 sysctl -p
docker exec -it clab-trex-ubtrex05 systemctl start trex
docker exec -it clab-trex-ubtrex05 ip addr add 10.101.5.2/24 dev eth1
docker exec -it clab-trex-ubtrex05 ip addr add fc00:0:101:5::105/64 dev eth1
docker exec -it clab-trex-ubtrex05 ip route add 10.0.0.0/8 via 10.101.5.1 dev eth1
docker exec -it clab-trex-ubtrex05 ip -6 route add fc00:0000::/32 via fc00:0:101:5::1 dev eth1

## ubuntu trex 06
#docker exec -it clab-trex-ubtrex06 sysctl -p
docker exec -it clab-trex-ubtrex06 systemctl start trex
docker exec -it clab-trex-ubtrex06 ip addr add 10.101.6.2/24 dev eth1
docker exec -it clab-trex-ubtrex06 ip addr add fc00:0:101:6::106/64 dev eth1
docker exec -it clab-trex-ubtrex06 ip route add 10.0.0.0/8 via 10.101.6.1 dev eth1
docker exec -it clab-trex-ubtrex06 ip -6 route add fc00:0000::/32 via fc00:0:101:6::1 dev eth1

## ubuntu trex 07
#docker exec -it clab-trex-ubtrex07 sysctl -p
docker exec -it clab-trex-ubtrex07 systemctl start trex
docker exec -it clab-trex-ubtrex07 ip addr add 10.101.7.2/24 dev eth1
docker exec -it clab-trex-ubtrex07 ip addr add fc00:0:101:7::107/64 dev eth1
docker exec -it clab-trex-ubtrex07 ip route add 10.0.0.0/8 via 10.101.7.1 dev eth1
docker exec -it clab-trex-ubtrex07 ip -6 route add fc00:0000::/32 via fc00:0:101:7::1 dev eth1

## ubuntu trex 08
#docker exec -it clab-trex-ubtrex08 sysctl -p
docker exec -it clab-trex-ubtrex08 systemctl start trex
docker exec -it clab-trex-ubtrex08 ip addr add 10.101.8.2/24 dev eth1
docker exec -it clab-trex-ubtrex08 ip addr add fc00:0:101:8::108/64 dev eth1
docker exec -it clab-trex-ubtrex08 ip route add 10.0.0.0/8 via 10.101.8.1 dev eth1
docker exec -it clab-trex-ubtrex08 ip -6 route add fc00:0000::/32 via fc00:0:101:8::1 dev eth1

## ubuntu trex 09
#docker exec -it clab-trex-ubtrex09 sysctl -p
docker exec -it clab-trex-ubtrex09 systemctl start trex
docker exec -it clab-trex-ubtrex09 ip addr add 10.101.9.2/24 dev eth1
docker exec -it clab-trex-ubtrex09 ip addr add fc00:0:101:9::109/64 dev eth1
docker exec -it clab-trex-ubtrex09 ip route add 10.0.0.0/8 via 10.101.9.1 dev eth1
docker exec -it clab-trex-ubtrex09 ip -6 route add fc00:0000::/32 via fc00:0:101:9::1 dev eth1

## ubuntu trex 10
#docker exec -it clab-trex-ubtrex10 sysctl -p
docker exec -it clab-trex-ubtrex10 systemctl start trex
docker exec -it clab-trex-ubtrex10 ip addr add 10.101.10.2/24 dev eth1
docker exec -it clab-trex-ubtrex10 ip addr add fc00:0:101:10::110/64 dev eth1
docker exec -it clab-trex-ubtrex10 ip route add 10.0.0.0/8 via 10.101.10.1 dev eth1
docker exec -it clab-trex-ubtrex10 ip -6 route add fc00:0000::/32 via fc00:0:101:10::1 dev eth1