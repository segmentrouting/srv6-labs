#!/bin/bash

sudo brctl addbr sonic07-host1
sudo brctl addbr sonic07-host2
sudo brctl addbr sonic08-host1
sudo brctl addbr sonic08-host2
sudo brctl addbr sonic09-host1
sudo brctl addbr sonic09-host2
sudo brctl addbr sonic10-host1
sudo brctl addbr sonic10-host2

sudo ip link set sonic07-host1 up
sudo ip link set sonic07-host2 up
sudo ip link set sonic08-host1 up
sudo ip link set sonic08-host2 up
sudo ip link set sonic09-host1 up
sudo ip link set sonic09-host2 up
sudo ip link set sonic10-host1 up
sudo ip link set sonic10-host2 up
