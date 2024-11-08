#/bin/sh

sudo brctl addbr xrd06-host
sudo brctl addbr xrd09-host
sudo brctl addbr xrd35-host
sudo brctl addbr xrd44-host
sudo brctl addbr xrd45-host

sudo ip link set up xrd06-host
sudo ip link set up xrd09-host
sudo ip link set up xrd35-host
sudo ip link set up xrd44-host
sudo ip link set up xrd45-host