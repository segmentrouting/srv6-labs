#/bin/sh

sudo brctl addbr xrd06-host
sudo brctl addbr xrd09-host
sudo brctl addbr xrd46-host
sudo brctl addbr frr96-host

sudo ip link set up xrd06-host
sudo ip link set up xrd09-host
sudo ip link set up xrd46-host
sudo ip link set up frr96-host