#/bin/sh

# Test 1: congest link from xrd01 to xrd02 by running traffic 
# xrd09 -> xrd01
# xrd03 -> xrd02

# IP addresses and routes
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.2/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.3/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.4/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.5/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.6/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.7/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.8/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.9/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.10/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.11/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.12/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.13/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.14/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.15/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.16/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add fc00:0:101:1::2/64 dev eth1
docker exec -it clab-peterson-trex01 ip route add 10.0.0.0/8 via 10.101.1.1 dev eth1
docker exec -it clab-peterson-trex01 ip -6 route add fc00:0000::/32 via fc00:0:101:1::1 dev eth1

docker exec -it clab-peterson-trex02 ip addr add 10.101.2.2/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.3/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.4/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.5/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.6/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.7/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.8/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.9/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.10/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.11/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.12/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.13/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.14/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.15/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add 10.101.2.16/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add fc00:0:101:2::2/64 dev eth1
docker exec -it clab-peterson-trex02 ip route add 10.0.0.0/8 via 10.101.2.1 dev eth1
docker exec -it clab-peterson-trex02 ip -6 route add fc00:0000::/32 via fc00:0:101:2::1 dev eth1

docker exec -it clab-peterson-trex03 ip addr add 10.101.3.2/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.1.3/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.4/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.5/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.6/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.7/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.8/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.9/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.10/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.11/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.12/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.13/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.14/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.15/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add 10.101.3.16/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add fc00:0:101:3::2/64 dev eth1
docker exec -it clab-peterson-trex03 ip route add 10.0.0.0/8 via 10.101.3.1 dev eth1
docker exec -it clab-peterson-trex03 ip -6 route add fc00:0000::/32 via fc00:0:101:3::1 dev eth1

docker exec -it clab-peterson-trex04 ip addr add 10.101.4.2/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.3/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.4/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.5/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.6/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.7/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.8/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.9/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.10/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.11/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.12/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.13/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.14/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.15/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add 10.101.4.16/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add fc00:0:101:4::2/64 dev eth1
docker exec -it clab-peterson-trex04 ip route add 10.0.0.0/8 via 10.101.4.1 dev eth1
docker exec -it clab-peterson-trex04 ip -6 route add fc00:0000::/32 via fc00:0:101:4::1 dev eth1

docker exec -it clab-peterson-trex05 ip addr add 10.101.5.2/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.3/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.4/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.5/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.6/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.7/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.8/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.9/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.10/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.11/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.12/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.13/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.14/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.15/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add 10.101.5.16/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add fc00:0:101:5::2/64 dev eth1
docker exec -it clab-peterson-trex05 ip route add 10.0.0.0/8 via 10.101.5.1 dev eth1
docker exec -it clab-peterson-trex05 ip -6 route add fc00:0000::/32 via fc00:0:101:5::1 dev eth1

docker exec -it clab-peterson-trex09 ip addr add 10.101.9.2/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.3/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.4/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.5/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.6/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.7/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.8/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.9/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.10/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.11/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.12/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.13/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.14/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.15/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add 10.101.9.16/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add fc00:0:101:9::2/64 dev eth1
docker exec -it clab-peterson-trex09 ip route add 10.0.0.0/8 via 10.101.9.1 dev eth1
docker exec -it clab-peterson-trex09 ip -6 route add fc00:0000::/32 via fc00:0:101:9::1 dev eth1
