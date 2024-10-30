#!/bin/sh

sudo brctl addbr br01t02n00-host
sudo brctl addbr br01t02n01-host
sudo brctl addbr br01t02n02-host
sudo brctl addbr br01t02n03-host

sudo brctl addbr br02t02n00-host
sudo brctl addbr br02t02n01-host
sudo brctl addbr br02t02n02-host
sudo brctl addbr br02t02n03-host

sudo ip link set up br01t02n00-host
sudo ip link set up br01t02n01-host
sudo ip link set up br01t02n02-host
sudo ip link set up br01t02n03-host

sudo ip link set up br02t02n00-host
sudo ip link set up br02t02n01-host
sudo ip link set up br02t02n02-host
sudo ip link set up br02t02n03-host