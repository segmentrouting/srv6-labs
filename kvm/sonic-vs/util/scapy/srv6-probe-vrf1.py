#! /usr/bin python3

# pip3 install scapy
# sudo python3 srv6-probe-fabric.py

# Set log level to benefit from Scapy warnings
import logging
logging.getLogger("scapy").setLevel(0)

from scapy.all import *

p0 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:3:7:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p0.show()
sendp(p0, iface="sonic01-16", count=64)

