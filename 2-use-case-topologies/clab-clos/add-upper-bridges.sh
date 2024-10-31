#!/bin/sh

sudo brctl addbr sp00c00n00g1-host
sudo brctl addbr sp00c00n00g2-host

sudo brctl addbr sp00c01n00g1-host
sudo brctl addbr sp00c02n00g1-host
sudo brctl addbr sp00c03n00-host

sudo brctl addbr sp00c00n01-host
sudo brctl addbr sp00c01n01-host
sudo brctl addbr sp00c02n01-host
sudo brctl addbr sp00c03n01-host

sudo brctl addbr sp00c00n02-host
sudo brctl addbr sp00c01n02-host
sudo brctl addbr sp00c02n02-host
sudo brctl addbr sp00c03n02-host

sudo brctl addbr sp00c00n03-host
sudo brctl addbr sp00c01n03-host
sudo brctl addbr sp00c02n03-host
sudo brctl addbr sp00c03n03-host

sudo ip link set up sp00c00n00g1-host
sudo ip link set up sp00c00n00g2-host
sudo ip link set up sp00c01n00g1-host
sudo ip link set up sp00c02n00g1-host
sudo ip link set up sp00c03n00-host

sudo ip link set up sp00c00n01-host
sudo ip link set up sp00c01n01-host
sudo ip link set up sp00c02n01-host
sudo ip link set up sp00c03n01-host

sudo ip link set up sp00c00n02-host
sudo ip link set up sp00c01n02-host
sudo ip link set up sp00c02n02-host
sudo ip link set up sp00c03n02-host

sudo ip link set up sp00c00n03-host
sudo ip link set up sp00c01n03-host
sudo ip link set up sp00c02n03-host
sudo ip link set up sp00c03n03-host