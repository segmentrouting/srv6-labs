## SRv6 on VPP and Linux

### VPP Section
Assumptions: Ubuntu 20.04 or 18.04
These instructions will result in a VM that uses VPP as its gateway (think of VPP as a VNF sitting between Linux and the outside network):

```
linux -- host-out/vpp-in -- VPP -- VM-NIC -- outside network
```

1. Install VPP:
   https://fd.io/docs/vpp/v2101/gettingstarted/installing/ubuntu.html


2. Edit /etc/vpp/startup.conf and add this line to the 'unix' section:
```
startup-config /etc/vpp/vpp-running.conf
```

3. Edit vpp-running.conf to fit your lab environment then copy it to the /etc/vpp/ directory
```
brmcdoug@ubuntu-vpp:~$ ls /etc/vpp/
startup.conf  vpp-running.conf
```

4. Edit netplan to look something like netplan.yaml in this repo. Key is the host-to-vpp -> vpp{} section as that creates the veth pair to connect linux to your VPP's "host interface".
   
5. Restart netplan
```
sudo netplan apply
```

6. Restart VPP
```
sudo systemctl restart vpp
```

7. Access VPP CLI and verify config:
```
brmcdoug@ubuntu-vpp:~$ sudo vppctl
    _______    _        _   _____  ___ 
 __/ __/ _ \  (_)__    | | / / _ \/ _ \
 _/ _// // / / / _ \   | |/ / ___/ ___/
 /_/ /____(_)_/\___/   |___/_/  /_/    

vpp# show interface address
GigabitEthernet0/7/0 (up):
  L3 10.10.46.3/24
  L3 fc00:0:46:1::3/64
host-vpp-in (up):
  L3 10.11.46.1/24
  L3 fc00:0:46:2::1/64
local0 (dn):
vpp# 
```

8. Add SRv6 policies and steering instructions to VPP. For return traffic note the 'sr localsid' line in vpp-running.conf

```
sr policy add bsid 1::1 next fc00:0:104:108:111:e006:: encap
sr policy add bsid 1::2 next fc00:0:105:109:111:e006:: encap
sr steer l3 10.10.1.0/24 via bsid 1::1
sr steer l3 10.10.2.0/24 via bsid 1::2
```

### Linux kernel SRv6 Section

Same assumptions re: Ubuntu

1. Add ip route specifying SRv6 encap. Note the uSID post-steering bits should match VPP's sr localsid:
```
ip route add 10.11.46.0/24 encap seg6 mode encap segs fc00:0:7:1:46:1::4 dev ens7
```   

2. Add a linux srv6 localsid: https://segment-routing.org/index.php/Implementation/AdvancedConf
   I haven't done this yet, but will try it out soon
