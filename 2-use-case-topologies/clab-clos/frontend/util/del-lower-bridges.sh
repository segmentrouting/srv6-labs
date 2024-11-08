#!/bin/bash

sudo ip link set down SP16-host
sudo ip link set down SP17-host
sudo ip link set down SP18-host
sudo ip link set down SP19-host

sudo ip link set down SP32-host
sudo ip link set down SP33-host
sudo ip link set down SP34-host
sudo ip link set down SP35-host

sudo brctl delbr SP16-host
sudo brctl delbr SP17-host
sudo brctl delbr SP18-host
sudo brctl delbr SP19-host

sudo brctl delbr SP32-host
sudo brctl delbr SP33-host
sudo brctl delbr SP34-host
sudo brctl delbr SP35-host


