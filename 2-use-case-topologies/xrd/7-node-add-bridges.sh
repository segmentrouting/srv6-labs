#!/bin/sh

sudo brctl addbr xrd01-host
sudo brctl addbr xrd07-host

sudo ip link set up xrd01-host
sudo ip link set up xrd07-host