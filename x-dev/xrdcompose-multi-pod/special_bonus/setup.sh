#/bin/sh

# this script was developed to run in an AWS environment
# it launches an XRd topology and connects to the host VM 
# and a VPP instance running on another AWS VM

echo "starting setup: " >> /home/ubuntu/startup.log

./xr-compose -f docker-compose-6-node.yml  -li localhost/ios-xr:7.8.1.18I
sudo sysctl -p
echo "sleeping for 10 seconds to let images build" >> /home/ubuntu/startup.log
sleep 10

docker network ls | awk -F': ' '/ubuntu_source-xrd-25 /{print $0}' > bridge25.txt
br25=$( head -n 1 bridge25.txt | cut -c 1-12 )
sudo ip addr del 10.0.25.1/24 dev br-"$br25"
sudo ip addr add 10.0.25.3/24 dev br-"$br25"
sudo ip route add 10.0.0.1/32 via 10.0.25.1 dev br-"$br25"

sudo vppctl create tap id 1 host-if-name eth1
sudo vppctl set interface state tap1 up
sudo vppctl set interface ip address tap1 10.10.4.1/24  
sudo vppctl set interface ip address tap1 fc00:0:10:4::1/64
sudo ip link set eth1 up

docker network ls | awk -F': ' '/ubuntu_xrd-29-host /{print $0}' > bridge29.txt
br29=$( head -n 1 bridge29.txt | cut -c 1-12 )
printf 'figured out bridge 29:  br-%s\n' "$br29"
sudo ip addr del 10.10.29.1/24 dev br-"$br29"
sudo ip addr add 10.10.4.3/24 dev br-"$br29"
sudo ip route add 10.10.2.0/24 via 10.10.4.1 dev br-"$br29"
#sudo ip addr add 10.10.4.3/24 dev br-"$br29"
#sudo ip addr add fc00:0:10:4::3/64 dev br-"$br29"

sudo brctl addif br-"$br29" eth1

sudo iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8055 -j DNAT --to-destination 10.0.0.1:8055
sudo iptables -t nat -A POSTROUTING -o br-"$br29" -j MASQUERADE 

sudo ip link add name host-return type veth peer name vpp-out
sudo vppctl create host-interface name vpp-out
sudo vppctl set interface state host-vpp-out up
sudo vppctl set interface ip address host-vpp-out 10.10.3.2/24
sudo vppctl set interface ip address host-vpp-out fc00:0:10:3::2/64

sudo vppctl ip route add 0.0.0.0/0 via 10.10.4.2 tap1
sudo vppctl ip route add ::/0 via fc00:0:10:4::2 tap1
sudo vppctl ip route add 10.0.0.1/32 via 10.10.3.1 host-vpp-out
sudo vppctl ip route add 10.10.1.0/24 via 10.10.3.1 host-vpp-out
sudo vppctl ip route add 10.10.2.0/24 via 10.10.3.1 host-vpp-out
sudo vppctl ip route add fc00:0:10:1::/64 via fc00:0:10:3::1 host-vpp-out
sudo vppctl ip route add fc00:0:10:2::/64 via fc00:0:10:3::1 host-vpp-out

sudo ip netns add vpp-out

ifconfig br-"$br25"
ifconfig br-"$br29"

sudo vppctl show int addr


sudo ip netns add vpp-out
sudo ip link set host-return netns vpp-out
sudo ip link set ens6 netns vpp-out
sudo ip netns exec vpp-out /bin/bash