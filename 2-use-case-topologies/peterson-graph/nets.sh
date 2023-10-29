#/bin/sh

sudo brctl addbr xrd01-host
sudo brctl addbr xrd02-host
sudo brctl addbr xrd03-host
sudo brctl addbr xrd04-host
sudo brctl addbr xrd05-host
sudo brctl addbr xrd06-host
sudo brctl addbr xrd07-host
sudo brctl addbr xrd08-host
sudo brctl addbr xrd09-host
sudo brctl addbr xrd10-host

sudo ip link set xrd01-host up
sudo ip link set xrd02-host up
sudo ip link set xrd03-host up
sudo ip link set xrd04-host up
sudo ip link set xrd05-host up
sudo ip link set xrd06-host up
sudo ip link set xrd07-host up
sudo ip link set xrd08-host up
sudo ip link set xrd09-host up
sudo ip link set xrd10-host up