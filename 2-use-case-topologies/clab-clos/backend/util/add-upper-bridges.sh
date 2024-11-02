#!/bin/sh

sudo brctl addbr SS01-host
sudo brctl addbr SS02-host
sudo brctl addbr SS03-host
sudo brctl addbr SS04-host
sudo brctl addbr SS05-host
sudo brctl addbr SS06-host
sudo brctl addbr SS07-host
sudo brctl addbr SS08-host

sudo brctl addbr LF65-host1
sudo brctl addbr LF66-host1
sudo brctl addbr LF67-host1
sudo brctl addbr LF68-host1
sudo brctl addbr LF65-host2
sudo brctl addbr LF66-host2
sudo brctl addbr LF67-host2
sudo brctl addbr LF68-host2

sudo ip link set up SS01-host
sudo ip link set up SS02-host
sudo ip link set up SS03-host
sudo ip link set up SS04-host
sudo ip link set up SS05-host
sudo ip link set up SS06-host
sudo ip link set up SS07-host
sudo ip link set up SS08-host

sudo ip link set up LF65-host1
sudo ip link set up LF66-host1
sudo ip link set up LF67-host1
sudo ip link set up LF68-host1

sudo ip link set up LF65-host2
sudo ip link set up LF66-host2
sudo ip link set up LF67-host2
sudo ip link set up LF68-host2
