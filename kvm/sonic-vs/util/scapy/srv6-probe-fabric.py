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

p1 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:3:8:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p1.show()
sendp(p1, iface="sonic01-16", count=64)

p2 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:3:9:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p2.show()
sendp(p2, iface="sonic01-16", count=64)

p3 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:3:10:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p3.show()
sendp(p3, iface="sonic01-16", count=64)

p4 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:4:7:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p4.show()
sendp(p4, iface="sonic01-16", count=64)

p5 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:4:8:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p5.show()
sendp(p5, iface="sonic01-16", count=64)

p6 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:4:9:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p6.show()
sendp(p6, iface="sonic01-16", count=64)

p7 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:4:10:11:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p7.show()
sendp(p7, iface="sonic01-16", count=64)


p8 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:5:7:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p8.show()
sendp(p8, iface="sonic01-16", count=64)

p9 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/IPv6(src = "2001:0:101:1::4", dst = "fc00:0:5:8:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p9.show()
sendp(p9, iface="sonic01-16", count=64)

p10 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:5:9:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p10.show()
sendp(p10, iface="sonic01-16", count=64)

p11 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:5:10:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p11.show()
sendp(p11, iface="sonic01-16", count=64)

p12 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:6:7:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p12.show()
sendp(p12, iface="sonic01-16", count=64)

p13 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:6:8:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p13.show()
sendp(p13, iface="sonic01-16", count=64)

p14 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:6:9:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p14.show()
sendp(p14, iface="sonic01-16", count=64)

p15 = Ether(src = "fe:54:00:33:cd:75", dst = "52:54:00:74:c1:01") \
/ IPv6(src = "2001:0:101:1::4", dst = "fc00:0:6:10:12:1:6500::") \
/ IP(src = "10.101.11.1", dst = "10.101.1.4") / ICMP()
p15.show()
sendp(p15, iface="sonic01-16", count=64)