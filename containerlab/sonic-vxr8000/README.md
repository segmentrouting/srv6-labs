### Cisco vxr8000 running SONiC

Installation instructions
=================================================================

#### Many thanks to Rafal Skorka for providing the original instructions

Note (July 21, 2023): SRv6 uSID support on SONiC vxr8000 is pending further development

1. Host server requirements

   - verify that Open vSwitch is installed
     ovs-vsctl --version
```
sudo apt-get install openvswitch-switch qemu qemu-kvm libvirt-bin -y
```

   - limit /proc/sys/kernel/pid_max to 1048575
     sysctl -w kernel.pid_max=1048575

   - make sure KVM modules are installed and configured
     file /dev/kvm (the output should be /dev/kvm: character special)

   - cpu and memory: recommend 20GB and 4 cores per router

2. Install Containerlab:
```
https://containerlab.dev/install/
```

1. Install 8000 SONiC docker image
```   
docker load -i c8000-clab-sonic:27.tar.gz
```

1. Copy sonic-cisco-8000.bin image to local storage (e.g. /sonic_images). Example:
```
ls /opt/images/ | grep sonic

c8000-clab-sonic:27.tar.gz
sonic-cisco-8000.bin
sonic-README
sonic.tar
```

4. Create a simple SONiC back-to-back clab topology file

    - NOTE: we will be using 'linux' ContainerLab kind to boot sonic images

cat example.yml
```
name: sonic

topology:
  kinds:
    linux:
        image: c8000-clab-sonic:27
        binds: 
            - /opt/images:/images
        env:
            IMAGE: /images/sonic-cisco-8000.bin
            PID: '8201-32FH'
  nodes:
    r1:
      kind: linux
    r2:
      kind: linux

  links:
    - endpoints: ["r1:eth1", "r2:eth1"]
    - endpoints: ["r1:eth2", "r2:eth2"]
```

#### NOTE: Data interfaces naming convention 
```
eth1 -> first front panel port  (Ethernet0)
eth2 -> second front panel port (Ethernet4 or Ethernet8)
```

#### NOTE: all X-node.yml topology files in this repo use Linux bridge to connect the clab routers. Be sure to create linux bridge instances prior to deploying the X-node.yml topologies:

```
sudo brctl addbr br1
sudo brctl addbr br2
sudo ip link set br1 up
sudo ip link set br2 up
etc.
```

5. Deploy topology
```
sudo containerlab deploy -t example.yml
```
 - example output:
```
cisco@vsonic:~/containerlab/vxrSONiC$ sudo containerlab deploy -t example.yml 
INFO[0000] Containerlab v0.38.0 started                 
INFO[0000] Parsing & checking topology file: example.yml 
INFO[0000] Creating lab directory: /home/cisco/containerlab/vxrSONiC/clab-c8201-sonic-3-node 
INFO[0000] Creating docker network: Name="clab", IPv4Subnet="172.20.20.0/24", IPv6Subnet="2001:172:20:20::/64", MTU="1500" 
INFO[0000] Creating container: "r1"                     
INFO[0000] Creating container: "r2"                     
INFO[0002] Creating virtual wire: r1:eth1 <--> r2:eth1  
INFO[0004] Adding containerlab host entries to /etc/hosts file 
+---+----------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
| # |            Name            | Container ID |        Image        | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+----------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
| 1 | clab-c8201-sonic-r1 | ca825396c86e | c8000-clab-sonic:27 | linux | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 2 | clab-c8201-sonic-r2 | bbda110e7e8f | c8000-clab-sonic:27 | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
+---+----------------------------+--------------+---------------------+-------+---------+----------------+----------------------+
```
   - NOTE: it may 10 or more minutes for SONiC to come up

6. Monitor sonic device bringup
```
docker logs -f clab-sonic-r1 
```
   - After a while, you should see this at the end of the log:
```
19:55:56 INFO Sim up
Router up
```
#### If you don't see "Router up" after 10 minutes, please share the "docker logs ..." output with Cisco team.

7. Test ssh to XR (either use SONiC default admin/YourPaSsWoRd or cisco/cisco123 login credentials)
```
sudo containerlab inspect -t example.yml |grep r1
```
```
| 1 | clab-sonic-r1 | 1edc2ce54d66 | c8000-clab-sonic:27 | linux | running | 172.20.20.3/24 | 2001:172:20:20::2/64 |
```
```
ssh cisco@172.20.20.3
cisco@172.20.20.3's password: 

Linux sonic 5.10.0-18-2-amd64 #1 SMP Debian 5.10.140-1 (2022-09-02) x86_64
You are on
  ____   ___  _   _ _  ____
 / ___| / _ \| \ | (_)/ ___|
 \___ \| | | |  \| | | |
  ___) | |_| | |\  | | |___
 |____/ \___/|_| \_|_|\____|

-- Software for Open Networking in the Cloud --

Last login: Tue Feb 21 19:56:42 2023 from 172.20.20.1
cisco@sonic:~$ 
```
8. Destroy topology
```
sudo containerlab destroy -t example.yml 
```

### SONiC serial console access

1. Telnet to serial console (port 60000)
```
docker exec -ti clab-sonic-r1 telnet 0 60000

Trying 0.0.0.0...
Connected to 0.
Escape character is '^]'.

sonic login: 
```
### Troubleshooting

1. check docker logs:
```
docker logs -f clab-sonic-r1
```   

2. Invoke bash shell of the relevant docker instance
```
docker exec -ti clab-sonic-r1 bash
root@r1:/#
```

3. Check vxr simulation status (make sure it is in ‘running’ state)
```
root@r1:/# cd /nobackup/
root@r1:/nobackup# vxr.py status
{"localhost": "running"}
```

4. If simulation not in 'running' state, invoke sim-check command
```
root@r1:/nobackup# vxr.py sim-check
```