import sys

# adding trex location to the system path
sys.path.insert(0, '/home/cisco/trex-v3.04/trex_client/interactive/')

from trex_stl_lib.api import *

a = STLClient(server = "172.20.99.101")
a.connect()
a.reset()
a.stop(ports = [0])

b = STLClient(server = "172.20.99.102")
b.connect()
b.reset()
b.stop(ports = [0])

c = STLClient(server = "172.20.99.103")
c.connect()
c.reset()
c.stop(ports = [0])

d = STLClient(server = "172.20.99.104")
d.connect()
d.reset()
d.stop(ports = [0])

e = STLClient(server = "172.20.99.105")
e.connect()
e.reset()
e.stop(ports = [0])

f = STLClient(server = "172.20.99.106")
f.connect()
f.reset()
f.stop(ports = [0])

g = STLClient(server = "172.20.99.107")
g.connect()
g.reset()
g.stop(ports = [0])

h = STLClient(server = "172.20.99.108")
h.connect()
h.reset()
h.stop(ports = [0])

i = STLClient(server = "172.20.99.109")
i.connect()
i.reset()
i.stop(ports = [0])

j = STLClient(server = "172.20.99.110")
j.connect()
j.reset()
j.stop(ports = [0])




