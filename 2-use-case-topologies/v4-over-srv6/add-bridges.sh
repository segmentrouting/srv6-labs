#!/bin/bash

sudo brctl addbr bridge00
sudo brctl addbr bridge01
sudo brctl addbr bridge02
sudo brctl addbr bridge03

sudo ip link set dev bridge00 up
sudo ip link set dev bridge01 up
sudo ip link set dev bridge02 up
sudo ip link set dev bridge03 up