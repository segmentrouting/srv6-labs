#!/bin/bash

sudo ip link set down br01t02n00-host
sudo ip link set down br02t02n00-host

sudo ip link set down br01t02n01-host
sudo ip link set down br02t02n01-host

sudo ip link set down br01t02n02-host
sudo ip link set down br02t02n02-host

sudo ip link set down br01t02n03-host
sudo ip link set down br02t02n03-host

sudo brctl delbr br01t02n00-host
sudo brctl delbr br02t02n00-host

sudo brctl delbr br01t02n01-host
sudo brctl delbr br02t02n01-host

sudo brctl delbr br01t02n02-host
sudo brctl delbr br02t02n02-host

sudo brctl delbr br01t02n03-host
sudo brctl delbr br02t02n03-host
