#/bin/sh

sudo brctl addbr xrd06-host
sudo brctl addbr xrd09-host
sudo brctl addbr xrd31-host
sudo brctl addbr xrd32-host
sudo brctl addbr xrd42-host
sudo brctl addbr xrd43-host

sudo ip link set up xrd06-host
sudo ip link set up xrd09-host
sudo ip link set up xrd31-host
sudo ip link set up xrd32-host
sudo ip link set up xrd42-host
sudo ip link set up xrd43-host