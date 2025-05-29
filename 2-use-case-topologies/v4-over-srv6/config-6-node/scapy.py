from scapy.all import *

payload = "testing, testing"
p0 = Ether(src = "aa:c1:ab:cc:5a:94", dst = "aa:c1:ab:9c:4d:00") \
/ IPv6(src = "2001:db8:101::1", dst = "2001:db8:102::1") \
/ UDP(sport=57777, dport=33333, chksum = 0x42)/payload

p0.show()
sendp(p0, iface="eth1", count=4)

