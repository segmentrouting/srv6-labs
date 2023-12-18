from trex_stl_lib.api import *

a = STLClient(server = "172.20.99.10")
a.connect()
a.reset()
a.start_line (" -f 1-imix.py -m 1mbps --port 0")

b = STLClient(server = "172.20.99.11")
b.connect()
b.reset()
b.start_line (" -f 2-imix.py -m 3mbps --port 0")

c = STLClient(server = "172.20.99.2")
c.connect()
c.reset()
c.start_line (" -f 3-imix.py -m 5mbps --port 0")

d = STLClient(server = "172.20.99.4")
d.connect()
d.reset()
d.start_line (" -f 4-imix.py -m 1mbps --port 0")

e = STLClient(server = "172.20.99.9")
e.connect()
e.reset()
e.start_line (" -f 5-imix.py -m 5mbps --port 0")

f = STLClient(server = "172.20.99.7")
f.connect()
f.reset()
f.start_line (" -f 6-imix.py -m 11mbps --port 0")

g = STLClient(server = "172.20.99.5")
g.connect()
g.reset()
g.start_line (" -f 7-imix.py -m 4mbps --port 0")

h = STLClient(server = "172.20.99.3")
h.connect()
h.reset()
h.start_line (" -f 8-imix.py -m 15mbps --port 0")

i = STLClient(server = "172.20.99.6")
i.connect()
i.reset()
i.start_line (" -f 9-imix.py -m 10mbps --port 0")

j = STLClient(server = "172.20.99.8")
j.connect()
j.reset()
j.start_line (" -f 10-imix.py -m 10mbps --port 0")

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




