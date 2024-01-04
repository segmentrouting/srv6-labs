
import sys

# adding trex location to the system path
sys.path.insert(0, '/home/cisco/trex-v3.04/trex_client/interactive/')

from trex_stl_lib.api import *

# trex01
a = STLClient(server = "172.20.99.101")
a.connect()
a.reset()
a.start_line (" -f trex01/1-imix.py -m 3mbps --port 0")

# trex02
b = STLClient(server = "172.20.99.102")
b.connect()
b.reset()
b.start_line (" -f trex02/2-imix.py -m 4mbps --port 0")

# trex03
c = STLClient(server = "172.20.99.103")
c.connect()
c.reset()
c.start_line (" -f trex03/3-imix.py -m 5mbps --port 0")

# trex04
d = STLClient(server = "172.20.99.104")
d.connect()
d.reset()
d.start_line (" -f trex04/4-imix.py -m 6mbps --port 0")

# trex05
e = STLClient(server = "172.20.99.105")
e.connect()
e.reset()
e.start_line (" -f trex05/5-imix.py -m 2mbps --port 0")

# trex06
f = STLClient(server = "172.20.99.106")
f.connect()
f.reset()
f.start_line (" -f trex06/6-imix.py -m 11mbps --port 0")

# trex07
g = STLClient(server = "172.20.99.107")
g.connect()
g.reset()
g.start_line (" -f trex07/7-imix.py -m 4mbps --port 0")

# trex08
h = STLClient(server = "172.20.99.108")
h.connect()
h.reset()
h.start_line (" -f trex08/8-imix.py -m 15mbps --port 0")

# trex09
i = STLClient(server = "172.20.99.109")
i.connect()
i.reset()
i.start_line (" -f trex09/9-imix.py -m 10mbps --port 0")

# trex10
j = STLClient(server = "172.20.99.110")
j.connect()
j.reset()
j.start_line (" -f trex10/10-imix.py -m 10mbps --port 0")

# a.stop(ports = [0])
# b.stop(ports = [0])
# c.stop(ports = [0])
# d.stop(ports = [0])
# e.stop(ports = [0])
# f.stop(ports = [0])
# g.stop(ports = [0])
# h.stop(ports = [0])
# i.stop(ports = [0])
# j.stop(ports = [0])




