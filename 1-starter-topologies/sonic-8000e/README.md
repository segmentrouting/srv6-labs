## Containerlab SONiC Cisco 8000 Emulator (8000e)

This repository contains instructions and sample yaml files for launching sonic running on the Cisco 8000 hardware emulator

Requires:

* Containerlab v0.40.0: https://containerlab.dev/
* c8000 docker image
* sonic-cisco-8000.bin 

### install and launch 

#### Many thanks to Rafal Skorka for providing the original instructions

Note (Oct 1, 2023): SRv6 uSID support on SONiC 8000e is pending further development

1. Host server requirements

   Resources: 8000 hardware emulator nodes require 4 vCPU and 20GB of memory each

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

1. Install containerlab: https://containerlab.dev/install/
   Or the quick and easy way:
   ```
   bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.40.0
   ```

2. Acquire and load 8000 SONiC docker image - contact Cisco account team to get access to Cisco 8000 SONiC docker images
```   
docker load -i c8000-clab-sonic:31.tar.gz
```

1.  Copy sonic-cisco-8000.bin image to local storage (e.g. /sonic_images). Example:
```
ls /opt/images/ | grep sonic

c8000-clab-sonic:31.tar.gz
sonic-cisco-8000.bin
sonic-README
sonic.tar
```
5. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
   ```
   kernel.pid_max=1048575
   ```
   Then reset sysctl: 
   ```
   sudo sysctl -p
   ```
   Example:
   ```
    brmcdoug@ie-dev7:~/srv6-labs/clab-quickstart$ sudo sysctl -p
    fs.inotify.max_user_watches = 131072
    fs.inotify.max_user_instances = 131072
    net.bridge.bridge-nf-call-iptables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    kernel.pid_max = 1048575
   ```
     
6. Validate KVM modules are installed and configured:
   ```
   file /dev/kvm
   ```
   output should look something like:
   ```
   brmcdoug@ie-dev8:~$ file /dev/kvm
   /dev

#### NOTE: if you wish to use Linux bridge to connect the clab routers, be sure to create linux bridge instances prior to deploying the X-node.yml topologies:

```
sudo brctl addbr br1
sudo brctl addbr br2
sudo ip link set br1 up
sudo ip link set br2 up
etc.
```

8.  Change directory to the location of the topology you wish to work with
    Example: 
    ```
    cd srv6-labs/1-starter-topologies/sonic-8000e/4-node
    ```
   
9.  Deploy topology
    ```
    sudo containerlab deploy -t clab-4-node-8000e.yml
    ```
 - example output:



```
   - NOTE: it may 10 or more minutes for SONiC to come up

7. Monitor sonic device bringup
```
docker logs -f clab-sonic-r1 
```
   - After a while, you should see this at the end of the log:
```
19:55:56 INFO Sim up
Router up
```
#### If you don't see "Router up" after 10-15 minutes, please share the "docker logs ..." output with Cisco team.

8. Test ssh to XR (either use SONiC default admin/YourPaSsWoRd or cisco/cisco123 login credentials)
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
9. Destroy topology
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