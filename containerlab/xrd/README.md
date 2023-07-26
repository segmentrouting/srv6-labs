### Quick start
The 7-node topology is based on https://github.com/jalapeno/SRv6_dCloud_Lab

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
3. Load XRd docker image:
```
docker load -i xrd-control-plane-container-x64.dockerv1.tgz 
``` 
4. Define/edit topology yml file
5. If using the linux bridge topology file run the create-bridges.sh script
   - XRd's will connect to each other via linux bridge instances, which is handy for doing tcpdump, etc.)
  ```
  sudo ./create-bridges.sh
  ```
6. Launch topology
```
sudo containerlab deploy -t 7-node-linux-bridge.yml
```
Example console output

```
brmcdoug@naja:~/srv6-labs/containerlab/xrd$ sudo containerlab40 deploy -t 7-node-v2.yml 
INFO[0000] Containerlab v0.40.0 started                 
INFO[0000] Parsing & checking topology file: 7-node-v2.yml 
INFO[0000] Creating lab directory: /home/brmcdoug/srv6-labs/containerlab/xrd/clab-xrd-7-node 
INFO[0000] Creating container: "xrd07"                  
INFO[0000] Creating container: "xrd06"                  
INFO[0000] Creating container: "xrd02"                  
INFO[0000] Creating container: "xrd03"                  
INFO[0000] Creating container: "xrd01"                  
INFO[0000] Creating container: "xrd04"                  
INFO[0000] Creating container: "xrd05"                  
INFO[0006] Creating virtual wire: xrd06:Gi0-0-0-0 <--> xrd07:Gi0-0-0-2 
INFO[0007] Creating virtual wire: xrd02:Gi0-0-0-1 <--> xrd03:Gi0-0-0-0 
INFO[0007] Creating virtual wire: xrd02:Gi0-0-0-2 <--> xrd06:Gi0-0-0-1 
INFO[0009] Creating virtual wire: xrd05:Gi0-0-0-2 <--> xrd06:Gi0-0-0-2 
INFO[0010] Creating virtual wire: xrd04:Gi0-0-0-1 <--> xrd07:Gi0-0-0-1 
INFO[0010] Creating virtual wire: xrd05:Gi0-0-0-1 <--> xrd04:Gi0-0-0-2 
INFO[0010] Creating virtual wire: xrd03:Gi0-0-0-1 <--> xrd04:Gi0-0-0-0 
INFO[0012] Creating virtual wire: xrd01:Gi0-0-0-2 <--> xrd05:Gi0-0-0-0 
INFO[0012] Creating virtual wire: xrd01:Gi0-0-0-1 <--> xrd02:Gi0-0-0-0 
INFO[0012] Adding containerlab host entries to /etc/hosts file 
INFO[0012] 🎉 New containerlab version 0.43.0 is available! Release notes: https://containerlab.dev/rn/0.43/
Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/ 
+---+-----------------------+--------------+-------------------------------------+-----------+---------+-----------------+-----------------------+
| # |         Name          | Container ID |                Image                |   Kind    |  State  |  IPv4 Address   |     IPv6 Address      |
+---+-----------------------+--------------+-------------------------------------+-----------+---------+-----------------+-----------------------+
| 1 | clab-xrd-7-node-xrd01 | 5777f7218f15 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.201/24 | 2001:172:20:5::201/80 |
| 2 | clab-xrd-7-node-xrd02 | b023d96c53a8 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.202/24 | 2001:172:20:5::202/80 |
| 3 | clab-xrd-7-node-xrd03 | 7cfd48828184 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.203/24 | 2001:172:20:5::203/80 |
| 4 | clab-xrd-7-node-xrd04 | b0ecdbb779d9 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.204/24 | 2001:172:20:5::204/80 |
| 5 | clab-xrd-7-node-xrd05 | d47b764f2300 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.205/24 | 2001:172:20:5::205/80 |
| 6 | clab-xrd-7-node-xrd06 | 60f56b56474e | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.206/24 | 2001:172:20:5::206/80 |
| 7 | clab-xrd-7-node-xrd07 | 87ff17bcc9e3 | ios-xr/xrd-control-plane:7.11.1.04E | cisco_xrd | running | 172.20.5.207/24 | 2001:172:20:5::207/80 |
+---+-----------------------+--------------+-------------------------------------+-----------+---------+-----------------+-----------------------+
brmcdoug@naja:~/srv6-labs/containerlab/xrd$ 
```

3. ssh to routers
```
ssh cisco@172.20.5.201
pw = cisco123
```