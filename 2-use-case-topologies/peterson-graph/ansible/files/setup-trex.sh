#/bin/sh

# Test 1: congest link from xrd01 to xrd02 by running traffic 
# xrd09 -> xrd01
# xrd03 -> xrd02

# IP addresses and routes



## ubuntu trex 01
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.1.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex01 ip addr add 10.101.5.101/24 dev eth2
docker exec -it clab-ubtrex-ubtrex01 ip addr add fc00:0:101:1::101/64 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip addr add fc00:0:101:5::101/64 dev eth2
docker exec -it clab-ubtrex-ubtrex01 ip route add 10.0.0.0/8 via 10.101.1.1 dev eth1
docker exec -it clab-ubtrex-ubtrex01 ip -6 route add fc00:0000::/32 via fc00:0:101:1::1 dev eth1

## ubuntu trex 02
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.2.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex02 ip addr add 10.101.6.102/24 dev eth2
docker exec -it clab-ubtrex-ubtrex02 ip addr add fc00:0:101:2::102/64 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip addr add fc00:0:101:6::102/64 dev eth2
docker exec -it clab-ubtrex-ubtrex02 ip route add 10.0.0.0/8 via 10.101.2.1 dev eth1
docker exec -it clab-ubtrex-ubtrex02 ip -6 route add fc00:0000::/32 via fc00:0:101:2::1 dev eth1

## ubuntu trex 03
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.3.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex03 ip addr add 10.101.7.103/24 dev eth2
docker exec -it clab-ubtrex-ubtrex03 ip addr add fc00:0:101:3::103/64 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip addr add fc00:0:101:7::103/64 dev eth2
docker exec -it clab-ubtrex-ubtrex03 ip route add 10.0.0.0/8 via 10.101.3.1 dev eth1
docker exec -it clab-ubtrex-ubtrex03 ip -6 route add fc00:0000::/32 via fc00:0:101:3::1 dev eth1

## ubuntu trex 04
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.4.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex04 ip addr add 10.101.8.104/24 dev eth2
docker exec -it clab-ubtrex-ubtrex04 ip addr add fc00:0:101:4::104/64 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip addr add fc00:0:101:8::104/64 dev eth2
docker exec -it clab-ubtrex-ubtrex04 ip route add 10.0.0.0/8 via 10.101.4.1 dev eth1
docker exec -it clab-ubtrex-ubtrex04 ip -6 route add fc00:0000::/32 via fc00:0:101:4::1 dev eth1

## ubuntu trex 05
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.5.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex05 ip addr add 10.101.9.105/24 dev eth2
docker exec -it clab-ubtrex-ubtrex05 ip addr add fc00:0:101:5::105/64 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip addr add fc00:0:101:9::105/64 dev eth2
docker exec -it clab-ubtrex-ubtrex05 ip route add 10.0.0.0/8 via 10.101.5.1 dev eth1
docker exec -it clab-ubtrex-ubtrex05 ip -6 route add fc00:0000::/32 via fc00:0:101:5::1 dev eth1

## ubuntu trex 06
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.6.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex06 ip addr add 10.101.10.106/24 dev eth2
docker exec -it clab-ubtrex-ubtrex06 ip addr add fc00:0:101:6::106/64 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip addr add fc00:0:101:10::106/64 dev eth2
docker exec -it clab-ubtrex-ubtrex06 ip route add 10.0.0.0/8 via 10.101.6.1 dev eth1
docker exec -it clab-ubtrex-ubtrex06 ip -6 route add fc00:0000::/32 via fc00:0:101:6::1 dev eth1

## ubuntu trex 07
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.7.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex07 ip addr add 10.101.1.107/24 dev eth2
docker exec -it clab-ubtrex-ubtrex07 ip addr add fc00:0:101:7::107/64 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip addr add fc00:0:101:1::107/64 dev eth2
docker exec -it clab-ubtrex-ubtrex07 ip route add 10.0.0.0/8 via 10.101.7.1 dev eth1
docker exec -it clab-ubtrex-ubtrex07 ip -6 route add fc00:0000::/32 via fc00:0:101:7::1 dev eth1

## ubuntu trex 08
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.8.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex08 ip addr add 10.101.2.108/24 dev eth2
docker exec -it clab-ubtrex-ubtrex08 ip addr add fc00:0:101:8::108/64 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip addr add fc00:0:101:2::108/64 dev eth2
docker exec -it clab-ubtrex-ubtrex08 ip route add 10.0.0.0/8 via 10.101.8.1 dev eth1
docker exec -it clab-ubtrex-ubtrex08 ip -6 route add fc00:0000::/32 via fc00:0:101:8::1 dev eth1

## ubuntu trex 09
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.9.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex09 ip addr add 10.101.3.109/24 dev eth2
docker exec -it clab-ubtrex-ubtrex09 ip addr add fc00:0:101:9::109/64 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip addr add fc00:0:101:3::109/64 dev eth2
docker exec -it clab-ubtrex-ubtrex09 ip route add 10.0.0.0/8 via 10.101.9.1 dev eth1
docker exec -it clab-ubtrex-ubtrex09 ip -6 route add fc00:0000::/32 via fc00:0:101:9::1 dev eth1

## ubuntu trex 10
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.101/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.102/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.103/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.104/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.105/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.106/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.107/24 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.10.108/24 dev eth1

docker exec -it clab-ubtrex-ubtrex10 ip addr add 10.101.34.110/24 dev eth2
docker exec -it clab-ubtrex-ubtrex10 ip addr add fc00:0:101:10::110/64 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip addr add fc00:0:101:4::110/64 dev eth2
docker exec -it clab-ubtrex-ubtrex10 ip route add 10.0.0.0/8 via 10.101.10.1 dev eth1
docker exec -it clab-ubtrex-ubtrex10 ip -6 route add fc00:0000::/32 via fc00:0:101:10::1 dev eth1