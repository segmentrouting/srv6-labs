#/bin/sh

sudo brctl addbr xrd06-host
sudo brctl addbr xrd09-host
sudo brctl addbr xrd31-host
sudo brctl addbr xrd32-host
sudo brctl addbr xrd44-host
sudo brctl addbr xrd45-host

sudo ip link set up xrd06-host
sudo ip link set up xrd09-host
sudo ip link set up xrd31-host
sudo ip link set up xrd32-host
sudo ip link set up xrd44-host
sudo ip link set up xrd45-host