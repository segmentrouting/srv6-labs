#!/bin/bash

sudo ip link set down sp00c00n00-host
sudo ip link set down sp00c00n01-host
sudo ip link set down sp00c00n02-host
sudo ip link set down sp00c00n03-host

sudo ip link set down sp00c01n00-host
sudo ip link set down sp00c01n01-host
sudo ip link set down sp00c01n02-host
sudo ip link set down sp00c01n03-host

sudo ip link set down sp00c02n00-host
sudo ip link set down sp00c02n01-host
sudo ip link set down sp00c02n02-host
sudo ip link set down sp00c02n03-host

sudo ip link set down sp00c03n00-host
sudo ip link set down sp00c03n01-host
sudo ip link set down sp00c03n02-host
sudo ip link set down sp00c03n03-host

sudo brctl delbr sp00c00n00-host
sudo brctl delbr sp00c00n01-host
sudo brctl delbr sp00c00n02-host
sudo brctl delbr sp00c00n03-host

sudo brctl delbr sp00c01n00-host
sudo brctl delbr sp00c01n01-host
sudo brctl delbr sp00c01n02-host
sudo brctl delbr sp00c01n03-host

sudo brctl delbr sp00c02n00-host
sudo brctl delbr sp00c02n01-host
sudo brctl delbr sp00c02n02-host
sudo brctl delbr sp00c02n03-host

sudo brctl delbr sp00c03n00-host
sudo brctl delbr sp00c03n01-host
sudo brctl delbr sp00c03n02-host
sudo brctl delbr sp00c03n03-host
