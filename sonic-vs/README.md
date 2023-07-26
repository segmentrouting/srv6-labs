# sonic-vs
This repo contains kvm/virsh xml and config files for launching and running a 12-node sonic-vs CLOS topology as shown in the diagram. There are two sets of router configurations, IPv6/BGP numbered and unnumbered, depending on your preference. The numbered and unnumbered folders contain their own READMEs as well.

More info on this lab and use case can be found here: https://www.segment-routing.net/blogs/srv6-usid-on-sonic/

<img src="/sonic-vs/diagrams/sonic-vs-clos.png" width="1200">

Requirements: 1 vCPU and 4GB memory per sonic-vs instance. The topology in this repo has been tested on an Ubuntu 20.04 host using virsh.

### sonic-vs launch instructions:
1. acquire a sonic-vs image - the full uSID-enabled image used in this repo/blog can be found here: https://onedrive.live.com/download?cid=266D2E4F35D86653&resid=266D2E4F35D86653%21138084&authkey=AN9P9j7tPoEU3iU

 - Official sonic images: https://sonic.software/

2. edit the image path in the sonic kvm xml files as needed
3. define and launch kvms:
```
sudo virsh define sonic01.xml
sudo virsh start sonic01
etc.
```

### attach to sonic-vs console port and get mgt IP
1. Find the sonic-vs node's console port as it is defined in the xml files:
   - Example from sonic01 xml:
```
    <console type='tcp'>
      <source mode='bind' host='127.0.0.1' service='8001'/>
      <protocol type='telnet'/>
      <target type='serial' port='0'/>
    </console>
```
2. telnet to console
```
telnet localhost 8001
```
 - sonic default user/pw: admin/YourPaSsWoRd

```
brmcdoug@naja:~/sonic$ telnet 0 8001
Trying 0.0.0.0...
Connected to 0.
Escape character is '^]'.

sonic login: admin
Password: 
Linux sonic 5.10.0-18-2-amd64 #1 SMP Debian 5.10.140-1 (2022-09-02) x86_64
You are on
  ____   ___  _   _ _  ____
 / ___| / _ \| \ | (_)/ ___|
 \___ \| | | |  \| | | |
  ___) | |_| | |\  | | |___
 |____/ \___/|_| \_|_|\____|

-- Software for Open Networking in the Cloud --

Unauthorized access and/or use are prohibited.
All access and/or use are subject to monitoring.

Help:    https://sonic-net.github.io/SONiC/

Last login: Sat Apr  8 02:33:24 UTC 2023 from 192.168.122.1 on pts/0
```
#### the xml files create a management port attached to linux bridge virbr0. virbr0 should allocate a DHCP address for the management port IP. Example:

3. sonic cli: show ip interfaces
``` 
show ip interfaces
```
Example output:
```
admin@sonic:~$ show ip interfaces 
Interface    Master    IPv4 address/mask    Admin/Oper    BGP Neighbor    Neighbor IP
-----------  --------  -------------------  ------------  --------------  -------------
docker0                240.127.1.1/24       up/down       N/A             N/A
eth0                   192.168.122.116/24   up/up         N/A             N/A   <--------------
lo                     127.0.0.1/16         up/up         N/A             N/A
admin@sonic:~$ 
```
### Configure sonic node

1. ssh to the management IP and scp the config files to the sonic instance. Example:
```
scp brmcdoug@192.168.122.1:/home/brmcdoug/sonic-vs/config-unnumbered/sonic01/* .
```
  
```
admin@sonic01:~$ scp brmcdoug@192.168.122.1:/home/brmcdoug/sonic-vs/config-unnumbered/sonic01/* .
brmcdoug@192.168.122.116's password: 
config_db.json   100% 8426     5.5MB/s   00:00    
frr.conf        100% 2383     3.1MB/s   00:00
```
2. The config_db.json file contains interface and device metadata config. Replace the original config_db.json file with the new one:
```
sudo mv config_db.json /etc/sonic/
```
3. reload sonic config:
```
sudo config reload
```
Output:
```
admin@sonic01:~$ sudo config reload
Clear current config and reload config in config_db format from the default config file(s) ? [y/N]: y
Disabling container monitoring ...
Stopping SONiC target ...
Running command: /usr/local/bin/sonic-cfggen  -j /etc/sonic/init_cfg.json  -j /etc/sonic/config_db.json  --write-to-db
Running command: /usr/local/bin/db_migrator.py -o migrate
Running command: /usr/local/bin/sonic-cfggen -d -y /etc/sonic/sonic_version.yml -t /usr/share/sonic/templates/sonic-environment.j2,/etc/sonic/sonic-environment
Restarting SONiC target ...
Enabling container monitoring ...
Reloading Monit configuration ...
Reinitializing monit daemon
```
Note: config reload takes a couple minutes, and interfaces coming up takes a couple minutes more

sonic CLI reference:
https://github.com/sonic-net/sonic-utilities/blob/master/doc/Command-Reference.md

Some handy CLI commands:
```
show interfaces status
show ip interfaces
show ipv6 interfaces
```
4. The frr.conf file contains BGP and SRv6 configurations. Invoke the FRR CLI, conf t, then paste in the config:
```
vtysh
```
Example:
```
admin@sonic01:~$ vtysh

Hello, this is FRRouting (version 8.4-dev).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

sonic01# 
sonic01# conf t
sonic01(config)#  <paste>
```

### Notes, caveats:

As of July 26, 2023:

1. The repo doesn't contain any config automation yet, hence the FRR copy/paste routine...submissions are welcome :)

2. The util directory contains some scapy scripts to generate ipv6 encapsulated packets to probe/test the SRv6 topology
   
3. SONiC-VS and the FRR implementation have a couple quirks to be aware of:

   - L3VPN forwarding requires setting the VRF strict mode sysctl kernel property:

```
admin@sonic01:~$ tail -f /etc/sysctl.conf 
net.ipv6.conf.eth0.keep_addr_on_down = 1
net.ipv4.tcp_l3mdev_accept = 1
net.ipv4.udp_l3mdev_accept = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.somaxconn = 512
net.ipv4.fib_multipath_use_neigh = 1

net.vrf.strict_mode = 1     <------------
```
 - after editing sysctl.conf reset sysctl
```
sudo sysctl -p
```
   - FRR may also apply some default settings for BGP and RT values after events like reloads, which require cleanup. I’ll discuss these items with the engineering team and see what we can do to correct that. In the meantime:

   ```
   no route-map RM_SET_SRC6 permit 10
   no route-map RM_SET_SRC permit 10
   no ip protocol bgp route-map RM_SET_SRC
   no ipv6 protocol bgp route-map RM_SET_SRC6
   ```
### Additional notes:

1. Full cleanout of stuff that frr might have in there by default 
```
no ip prefix-list PL_LoopbackV4 seq 5 permit 10.1.0.1/32
no route-map RM_SET_SRC6 permit 10
no route-map RM_SET_SRC permit 10
no ip protocol bgp route-map RM_SET_SRC
no ipv6 protocol bgp route-map RM_SET_SRC6

no bgp community-list standard allow_list_default_community seq 5 permit no-export
no bgp community-list standard allow_list_default_community seq 10 permit 5060:12345
no route-map ALLOW_LIST_DEPLOYMENT_ID_0_V4 permit 65535
no route-map ALLOW_LIST_DEPLOYMENT_ID_0_V6 permit 65535
no route-map FROM_BGP_PEER_V4 permit 10
no route-map FROM_BGP_PEER_V4 permit 11
no route-map FROM_BGP_PEER_V4 permit 100
no route-map FROM_BGP_PEER_V6 permit 1
no route-map FROM_BGP_PEER_V6 permit 10
no route-map FROM_BGP_PEER_V6 permit 11
no route-map FROM_BGP_PEER_V6 permit 100
no route-map TO_BGP_PEER_V4 permit 100
no route-map TO_BGP_PEER_V6 permit 100
```
6. if necessary fix bgp vpn RT settings (same note about Bug)
```
router bgp 65001 vrf Vrf1
 address-family ipv4 unicast
 rd vpn export 10.0.0.1:1
 rt vpn both 1:1
 exit-address-family
 address-family ipv6 unicast
 rd vpn export 10.0.0.1:1
 rt vpn both 1:1
```
7. Do 'show ipv6 route' in FRR. If BGP L3VPN SID is 'rejected', restart docker bgp container
Example:
```
B>r fc00:0:2:6500::/128 [20/0] is directly connected, Vrf1, seg6local uDT46 unknown(seg6local_context2str), flavors unknown(seg6local_context2str), seg6 ::, weight 1, 01:44:25
```
```
docker restart bgp
```
Now it should show something like:
```
sonic02# show ipv6 route
Codes: K - kernel route, C - connected, S - static, R - RIPng,
       O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
       v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

B>* fc00:0:1::/48 [20/0] via fc00:0:ffff::11, Ethernet4, weight 1, 00:09:49
B>* fc00:0:1::1/128 [20/0] via fc00:0:ffff::11, Ethernet4, weight 1, 00:09:49
S>* fc00:0:2::/48 [1/0] is directly connected, Loopback0, weight 1, 00:09:57
C>* fc00:0:2::1/128 is directly connected, Loopback0, 00:09:59
B>* fc00:0:2:6500::/128 [20/0] is directly connected, Vrf1, seg6local uDT46 unknown(seg6local_context2str), flavors unknown(seg6local_context2str), seg6 ::, weight 1, 00:09:54
```
8. Check sonic linux routes
```
admin@sonic01:~$ ip route show vrf Vrf1
10.10.101.0/24 dev Ethernet16 proto kernel scope link src 10.10.101.1 
10.10.201.0/24 nhid 233  encap seg6 mode encap segs 1 [ fc00:0:2:6500:: ] via inet6 fc00:0:ffff::3 dev Ethernet4 proto bgp metric 20 
```
9. Verify dataplane using tcpdump on sonic linux; example sonic PE egress interface:
```
admin@sonic01:~$ sudo tcpdump -ni Ethernet4
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on Ethernet4, link-type EN10MB (Ethernet), snapshot length 262144 bytes

04:51:54.905226 IP6 fe80::5054:ff:fe74:c104 > ff02::1: ICMP6, router advertisement, length 56
04:51:56.262226 IP6 fc00:0:1::1 > fc00:0:2:6500::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:2:6500::) IP 10.10.101.2 > 10.10.201.1: ICMP echo request, id 6248, seq 1, length 76
04:51:56.265307 IP6 fc00:0:2::1 > fc00:0:1:6500::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:6500::) IP 10.10.201.1 > 10.10.101.2: ICMP echo reply, id 6248, seq 1, length 76
```

### Appendix:

1. To manually configure a VRF on sonic linux
```
sudo config vrf add Vrf1
sudo config interface vrf bind Ethernet16 Vrf1
```
2. Possible bug: change to sonic/linux vrf IP results in FRR changing the vrf RT export values, thus breaking remote vrf RT imports
3. Possible bug: changes to sonic/linux config results in FRR re-adding the route-maps, etc. listed in step 5 above