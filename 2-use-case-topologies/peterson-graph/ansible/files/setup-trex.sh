#/bin/sh

# Test 1: congest link from xrd01 to xrd02 by running traffic 
# xrd09 -> xrd01
# xrd03 -> xrd02

# IP addresses and routes
docker exec -it clab-peterson-trex01 ip addr add 10.101.1.2/24 dev eth1
docker exec -it clab-peterson-trex01 ip addr add fc00:0:101:1::2/64 dev eth1
docker exec -it clab-peterson-trex01 ip route add 10.0.0.0/8 via 10.101.1.1 dev eth1
docker exec -it clab-peterson-trex01 ip -6 route add fc00:0000::/32 via fc00:0:101:1::1

docker exec -it clab-peterson-trex02 ip addr add 10.101.2.2/24 dev eth1
docker exec -it clab-peterson-trex02 ip addr add fc00:0:101:2::2/64 dev eth1
docker exec -it clab-peterson-trex02 ip route add 10.0.0.0/8 via 10.101.2.1 dev eth1
docker exec -it clab-peterson-trex02 ip -6 route add fc00:0000::/32 via fc00:0:101:2::1

docker exec -it clab-peterson-trex03 ip addr add 10.101.3.2/24 dev eth1
docker exec -it clab-peterson-trex03 ip addr add fc00:0:101:3::2/64 dev eth1
docker exec -it clab-peterson-trex03 ip route add 10.0.0.0/8 via 10.101.3.1 dev eth1
docker exec -it clab-peterson-trex03 ip -6 route add fc00:0000::/32 via fc00:0:101:3::1

docker exec -it clab-peterson-trex04 ip addr add 10.101.4.2/24 dev eth1
docker exec -it clab-peterson-trex04 ip addr add fc00:0:101:4::2/64 dev eth1
docker exec -it clab-peterson-trex04 ip route add 10.0.0.0/8 via 10.101.4.1 dev eth1
docker exec -it clab-peterson-trex04 ip -6 route add fc00:0000::/32 via fc00:0:101:4::1

docker exec -it clab-peterson-trex05 ip addr add 10.101.5.2/24 dev eth1
docker exec -it clab-peterson-trex05 ip addr add fc00:0:101:5::2/64 dev eth1
docker exec -it clab-peterson-trex05 ip route add 10.0.0.0/8 via 10.101.5.1 dev eth1
docker exec -it clab-peterson-trex05 ip -6 route add fc00:0000::/32 via fc00:0:101:5::1

docker exec -it clab-peterson-trex09 ip addr add 10.101.9.2/24 dev eth1
docker exec -it clab-peterson-trex09 ip addr add fc00:0:101:9::2/64 dev eth1
docker exec -it clab-peterson-trex09 ip route add 10.0.0.0/8 via 10.101.9.1 dev eth1
docker exec -it clab-peterson-trex09 ip -6 route add fc00:0000::/32 via fc00:0:101:9::1

# trex configs and startup daemon

docker cp trex01/trex_cfg.yaml clab-peterson-trex01:/etc/trex_cfg.yaml
docker exec -it clab-peterson-trex01 /opt/trex/v3.04/t-rex-64 -i &


docker cp trex02/trex_cfg.yaml clab-peterson-trex02:/etc/trex_cfg.yaml
docker exec -it clab-peterson-trex02 /opt/trex/v3.04/t-rex-64 -i &

