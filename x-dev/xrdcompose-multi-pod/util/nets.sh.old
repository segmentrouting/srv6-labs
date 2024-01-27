#/bin/bash

echo "list docker networks"
docker network ls

echo "mapping docker networks to bridge instance files"

docker network ls | awk -F': ' '/xrd01-gi1-xrd02-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd01-xrd02
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth1to2=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth1to2 root netem delay 10000

docker network ls | awk -F': ' '/xrd01-gi2-xrd05-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd01-xrd05
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth1to5=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth1to5 root netem delay 5000

docker network ls | awk -F': ' '/xrd02-gi1-xrd03-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd02-xrd03
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth2to3=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth2to3 root netem delay 30000

docker network ls | awk -F': ' '/xrd02-gi2-xrd06-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd02-xrd06
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth2to6=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth2to6 root netem delay 20000

docker network ls | awk -F': ' '/xrd03-gi1-xrd04-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd03-xrd04
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth3to4=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth3to4 root netem delay 40000

docker network ls | awk -F': ' '/xrd04-gi1-xrd07-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd04-xrd07
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth4to7=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth4to7 root netem delay 30000

docker network ls | awk -F': ' '/xrd04-gi2-xrd05-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd04-xrd05
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth4to5=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth4to5 root netem delay 60000

docker network ls | awk -F': ' '/xrd05-gi2-xrd06-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd05-xrd06
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth5to6=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth5to6 root netem delay 5000

docker network ls | awk -F': ' '/xrd06-gi0-xrd07-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > /home/cisco/SRv6_dCloud_Lab/util/xrd06-xrd07
echo br-"$netinstance"

brctl show | grep br-"$netinstance" > br.txt 
veth6to7=$(rev br.txt | cut -c -11 | rev ) 
sudo tc qdisc add dev $veth6to7 root netem delay 30000

sudo tc qdisc list | grep delay

rm net.txt
rm br.txt