#!/bin/sh

sudo brctl addbr SS00-host
sudo brctl addbr SS01-host
sudo brctl addbr SS02-host
sudo brctl addbr SS03-host
sudo brctl addbr SS04-host
sudo brctl addbr SS05-host
sudo brctl addbr SS06-host
sudo brctl addbr SS07-host

sudo ip link set up SS00-host
sudo ip link set up SS01-host
sudo ip link set up SS02-host
sudo ip link set up SS03-host
sudo ip link set up SS04-host
sudo ip link set up SS05-host
sudo ip link set up SS06-host
sudo ip link set up SS07-host
