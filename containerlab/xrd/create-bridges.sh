#/bin/sh

sudo brctl addbr xrd01-host
sudo brctl addbr xrd01-xrd02
sudo brctl addbr xrd01-xrd05
sudo brctl addbr xrd02-xrd03
sudo brctl addbr xrd02-xrd06
sudo brctl addbr xrd03-xrd04
sudo brctl addbr xrd04-xrd07
sudo brctl addbr xrd05-xrd04
sudo brctl addbr xrd05-xrd06
sudo brctl addbr xrd06-xrd07
sudo brctl addbr xrd07-host

sudo ip link set up xrd01-host
sudo ip link set up xrd01-xrd02
sudo ip link set up xrd01-xrd05
sudo ip link set up xrd02-xrd03
sudo ip link set up xrd02-xrd06
sudo ip link set up xrd03-xrd04
sudo ip link set up xrd04-xrd07
sudo ip link set up xrd05-xrd04
sudo ip link set up xrd05-xrd06
sudo ip link set up xrd06-xrd07
sudo ip link set up xrd07-host