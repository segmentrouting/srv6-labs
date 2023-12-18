from trex_stl_lib.api import *

a = STLClient(server = "172.20.99.10")
a.connect()
a.reset()
a.stop(ports = [0])

b = STLClient(server = "172.20.99.11")
b.connect()
b.reset()
b.stop(ports = [0])

c = STLClient(server = "172.20.99.2")
c.connect()
c.reset()
c.stop(ports = [0])

d = STLClient(server = "172.20.99.4")
d.connect()
d.reset()
d.stop(ports = [0])

e = STLClient(server = "172.20.99.9")
e.connect()
e.reset()
e.stop(ports = [0])

f = STLClient(server = "172.20.99.7")
f.connect()
f.reset()
f.stop(ports = [0])

g = STLClient(server = "172.20.99.5")
g.connect()
g.reset()
g.stop(ports = [0])

h = STLClient(server = "172.20.99.3")
h.connect()
h.reset()
h.stop(ports = [0])

i = STLClient(server = "172.20.99.6")
i.connect()
i.reset()
i.stop(ports = [0])

j = STLClient(server = "172.20.99.8")
j.connect()
j.reset()
j.stop(ports = [0])




