#!/bin/sh

sudo brctl addbr SP01-host
sudo brctl addbr SP02-host
sudo brctl addbr SP03-host
sudo brctl addbr SP04-host
sudo brctl addbr SP05-host
sudo brctl addbr SP06-host
sudo brctl addbr SP07-host
sudo brctl addbr SP08-host

sudo brctl addbr LF01-host1
sudo brctl addbr LF02-host1
sudo brctl addbr LF03-host1
sudo brctl addbr LF04-host1
sudo brctl addbr LF05-host1
sudo brctl addbr LF06-host1
sudo brctl addbr LF07-host1
sudo brctl addbr LF08-host1

sudo brctl addbr LF01-host2
sudo brctl addbr LF02-host2
sudo brctl addbr LF03-host2
sudo brctl addbr LF04-host2
sudo brctl addbr LF05-host2
sudo brctl addbr LF06-host2
sudo brctl addbr LF07-host2
sudo brctl addbr LF08-host2

sudo ip link set up SP01-host
sudo ip link set up SP02-host
sudo ip link set up SP03-host
sudo ip link set up SP04-host

sudo ip link set up SP05-host
sudo ip link set up SP06-host
sudo ip link set up SP07-host
sudo ip link set up SP08-host

sudo ip link set up LF01-host1
sudo ip link set up LF02-host1
sudo ip link set up LF03-host1
sudo ip link set up LF04-host1
sudo ip link set up LF05-host1
sudo ip link set up LF06-host1
sudo ip link set up LF07-host1
sudo ip link set up LF08-host1

sudo ip link set up LF01-host2
sudo ip link set up LF02-host2
sudo ip link set up LF03-host2
sudo ip link set up LF04-host2
sudo ip link set up LF05-host2
sudo ip link set up LF06-host2
sudo ip link set up LF07-host2
sudo ip link set up LF08-host2
