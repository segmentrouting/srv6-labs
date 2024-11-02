#!/bin/sh

sudo brctl addbr SP01-host
sudo brctl addbr SP02-host
sudo brctl addbr SP03-host
sudo brctl addbr SP04-host
sudo brctl addbr SP05-host
sudo brctl addbr SP06-host
sudo brctl addbr SP07-host
sudo brctl addbr SP08-host

sudo ip link set up SP01-host
sudo ip link set up SP02-host
sudo ip link set up SP03-host
sudo ip link set up SP04-host

sudo ip link set up SP05-host
sudo ip link set up SP06-host
sudo ip link set up SP07-host
sudo ip link set up SP08-host
