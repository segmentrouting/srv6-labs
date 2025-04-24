#!/bin/sh
ip addr add 10.17.1.2/24 dev eth1
ip route add 10.27.1.0/24 via 10.17.1.1 
ip addr add 10.17.2.2/24 dev eth2
ip route add 10.27.2.0/24 via 10.17.2.1
