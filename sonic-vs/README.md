# sonic-vs
This repo contains kvm xml and config files for launching and running a 12-node sonic-vs CLOS topology as shown in the diagram. There are two sets of router configurations, IPv6/BGP numbered and unnumbered, depending on your preference. The numbered and unnumbered folders contain their own READMEs as well.

<img src="/sonic-vs/diagrams/sonic-vs-clos.png" width="1200">

Requirements: 1 vCPU and 4GB memory per sonic-vs instance. The topology in this repo has been tested on an Ubuntu 20.04 host using virsh.

### sonic-vs launch instructions:
1. acquire a sonic-vs image
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
1. telnet to console
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

2. sonic cli: show ip interfaces
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
3. ssh to the management IP and scp the config files to the sonic instance. Example:
```
scp brmcdoug@192.168.122.1:/home/brmcdoug/sonic-vs/config-unnumbered/sonic01/* .
```
```
admin@sonic04:~$ scp brmcdoug@192.168.122.1:/home/brmcdoug/sonic-vs/config-unnumbered/sonic01/* .
brmcdoug@192.168.122.116's password: 
config_db.json   100% 8426     5.5MB/s   00:00    
frr.conf        100% 2383     3.1MB/s   00:00
```
4. The config_db.json file contains interface and device metadata config. Replace the original config_db.json file with the new one:
```
sudo mv config_db.json /etc/sonic/
```
5. reload sonic config:
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
6. The frr.conf file contains BGP and SRv6 configurations. Invoke the FRR CLI, conf t, then paste in the config:
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

As of May 15, 2023:

1. The repo doesn't contain any config automation yet, hence the FRR copy/paste routine...submissions are welcome :)

2. SONiC-VS and the FRR implementation have a couple quirks to be aware of:

   - L3VPN forwarding requires setting the VRF strict mode sysctl kernel property followed by a config reload:
   ```
   net.vrf.strict_mode = 1
   ```

   - FRR also applies some default settings for BGP and RT values after events like reloads, which require cleanup. I’ll discuss these items with the engineering team and see what we can do to correct that. In the meantime:

   ```
   no route-map RM_SET_SRC6 permit 10
   no route-map RM_SET_SRC permit 10
   no ip protocol bgp route-map RM_SET_SRC
   no ipv6 protocol bgp route-map RM_SET_SRC6
   ```
