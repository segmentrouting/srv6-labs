#!/bin/sh

sudo brctl addbr SP16-host
sudo brctl addbr SP17-host
sudo brctl addbr SP18-host
sudo brctl addbr SP19-host

sudo brctl addbr SP32-host
sudo brctl addbr SP33-host
sudo brctl addbr SP34-host
sudo brctl addbr SP35-host

sudo ip link set up SP16-host
sudo ip link set up SP17-host
sudo ip link set up SP18-host
sudo ip link set up SP19-host

sudo ip link set up SP32-host
sudo ip link set up SP33-host
sudo ip link set up SP34-host
sudo ip link set up SP35-host
