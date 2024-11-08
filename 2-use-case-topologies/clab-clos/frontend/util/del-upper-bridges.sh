#!/bin/bash

sudo ip link set down SS00-host
sudo ip link set down SS01-host
sudo ip link set down SS02-host
sudo ip link set down SS03-host

sudo ip link set down SS04-host
sudo ip link set down SS05-host
sudo ip link set down SS06-host
sudo ip link set down SS07-host

sudo brctl delbr SS00-host
sudo brctl delbr SS01-host
sudo brctl delbr SS02-host
sudo brctl delbr SS03-host

sudo brctl delbr SS04-host
sudo brctl delbr SS05-host
sudo brctl delbr SS06-host
sudo brctl delbr SS07-host
