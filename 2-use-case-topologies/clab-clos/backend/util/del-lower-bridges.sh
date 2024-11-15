#!/bin/bash

sudo ip link set down SP01-host
sudo ip link set down SP02-host
sudo ip link set down SP03-host
sudo ip link set down SP04-host
sudo ip link set down SP05-host
sudo ip link set down SP06-host
sudo ip link set down SP07-host
sudo ip link set down SP08-host

sudo brctl delbr SP01-host
sudo brctl delbr SP02-host
sudo brctl delbr SP03-host
sudo brctl delbr SP04-host
sudo brctl delbr SP05-host
sudo brctl delbr SP06-host
sudo brctl delbr SP07-host
sudo brctl delbr SP08-host

