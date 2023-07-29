#/bin/sh

sudo brctl addbr r1e0-r3e0
sudo brctl addbr r1e8-r3e8
sudo brctl addbr r1e16-r4e0
sudo brctl addbr r1e24-r4e8
sudo brctl addbr r1e32-host1
sudo brctl addbr r1e40-host2
sudo brctl addbr r2e0-r3e16
sudo brctl addbr r2e8-r3e24
sudo brctl addbr r2e16-r4e16
sudo brctl addbr r2e24-r4e24
sudo brctl addbr r2e32-host3
sudo brctl addbr r2e40-host4

sudo ip link set r1e0-r3e0 up
sudo ip link set r1e8-r3e8 up
sudo ip link set r1e16-r4e0 up
sudo ip link set r1e24-r4e8 up
sudo ip link set r1e32-host1 up
sudo ip link set r1e40-host2 up

sudo ip link set r2e0-r3e16 up
sudo ip link set r2e8-r3e24 up
sudo ip link set r2e16-r4e16 up
sudo ip link set r2e24-r4e24 up
sudo ip link set r2e32-host3 up
sudo ip link set r2e40-host4 up