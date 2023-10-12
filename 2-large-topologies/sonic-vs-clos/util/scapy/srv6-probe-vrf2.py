#! /usr/bin python3

# pip3 install scapy
# sudo python3 srv6-probe-fabric.py

# Set log level to benefit from Scapy warnings
import logging
logging.getLogger("scapy").setLevel(0)

from scapy.all import *

p0 = Ether(src = "fe:54:00:67:43:8b", dst = "52:54:00:74:c1:02") \
/ IPv6(src = "2001:0:102:2::3", dst = "fc00:0:12:1:6600::") \
/ IP(src = "10.102.12.1", dst = "10.102.2.3") / ICMP()
p0.show()
sendp(p0, iface="sonic02-20", count=64)

