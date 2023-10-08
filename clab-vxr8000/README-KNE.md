## Cisco 8000 hardware emulator (vxr8000) using KNE

The kne-4-node.yml launches a 4-node 8201-32FH emulator topology using KNE. The nodes get their configurations from those in the local config directory. In the provided example each node is dual connected to its neighbor per the topology diagram (single links shown):
 
####  r02---r03
####   | \  / |
####   |  \/  |
####   |  /\  |
####   | /  \ |
####  r00    r01

The sample 4-node topology in this repo consists of 4 emulated Cisco 8201-32FH nodes whose configurations are found in the *config* directory. The nodes are configured with basic ISIS, SR, SRv6, iBGP and streaming telemetry. 8201-r3 is a route-reflector with the other 3 nodes as clients. 

Please feel free to use this topology or add additional topologies and configurations, etc.

### Clab installation and topology deployment instructions: 

1. Containerlab requiress Ubuntu 20.04 or 22.04 bare-metal or VM, Docker, and Openvswitch
   
   Docker installation: https://docs.docker.com/engine/install/ubuntu/
   OVS installation:
   ```
   sudo apt-get install openvswitch-switch -y
   ```
   
2. Install containerlab: https://containerlab.dev/install/
   SRv6-Labs testing has been done with clab v 0.40.0, so the quick and easy way to install is:
   ```
   bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.40.0
   ```

3. Acquire vxr8000 router docker image(s)

4. Load docker image(s):
   ```
   docker load -i 8201-32fh-clab_7.9.1.tar.gz
   ``` 

5. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
   ```
   echo "kernel.pid_max=1048575" >> /etc/sysctl.conf
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
   /dev/kvm: character special (10/232)
   ```

7.  Modify configurations and the topology .yml file in this directory as needed. 
   
8.  Deploy your topology
    ```
    sudo containerlab deploy -t 4-node.yml
    ```

#### Example clab deploy terminal output
brmcdoug@naja:~/srv6-labs/clab-vxr8000$ sudo containerlab deploy -t 4-node-v2.yml 
INFO[0000] Containerlab v0.40.0 started                 
INFO[0000] Parsing & checking topology file: 4-node-v2.yml 
INFO[0000] Creating lab directory: /home/brmcdoug/srv6-labs/clab-vxr8000/clab-4-node 
INFO[0000] Creating docker network: Name="mgt_net6", IPv4Subnet="172.20.6.0/24", IPv6Subnet="2001:172:20:6::/80", MTU="1500" 
INFO[0000] Creating container: "8201-r4"                
INFO[0000] Creating container: "8201-r1"                
INFO[0000] Creating container: "8201-r2"                
INFO[0000] Creating container: "8201-r3"                
INFO[0006] Creating virtual wire: 8201-r2:FH0_0_0_0 <--> 8201-r3:FH0_0_0_2 
INFO[0006] Creating virtual wire: 8201-r2:FH0_0_0_1 <--> 8201-r3:FH0_0_0_3 
INFO[0007] Creating virtual wire: 8201-r1:FH0_0_0_0 <--> 8201-r3:FH0_0_0_0 
INFO[0007] Creating virtual wire: 8201-r1:FH0_0_0_1 <--> 8201-r3:FH0_0_0_1 
INFO[0008] Creating virtual wire: 8201-r3:FH0_0_0_5 <--> 8201-r4:FH0_0_0_5 
INFO[0008] Creating virtual wire: 8201-r2:FH0_0_0_2 <--> 8201-r4:FH0_0_0_2 
INFO[0008] Creating virtual wire: 8201-r1:FH0_0_0_3 <--> 8201-r4:FH0_0_0_1 
INFO[0008] Creating virtual wire: 8201-r1:FH0_0_0_2 <--> 8201-r4:FH0_0_0_0 
INFO[0008] Creating virtual wire: 8201-r2:FH0_0_0_3 <--> 8201-r4:FH0_0_0_3 
INFO[0008] Creating virtual wire: 8201-r3:FH0_0_0_4 <--> 8201-r4:FH0_0_0_4 
INFO[0009] Adding containerlab host entries to /etc/hosts file 
INFO[0009] 🎉 New containerlab version 0.45.1 is available! Release notes: https://containerlab.dev/rn/0.45/#0451
Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/ 
+---+---------------------+--------------+----------------------+-------+---------+-----------------+-----------------------+
| # |        Name         | Container ID |        Image         | Kind  |  State  |  IPv4 Address   |     IPv6 Address      |
+---+---------------------+--------------+----------------------+-------+---------+-----------------+-----------------------+
| 1 | clab-4-node-8201-r1 | 91af805218d4 | 8201-32fh-clab:7.9.1 | linux | running | 172.20.6.101/24 | 2001:172:20:6::101/80 |
| 2 | clab-4-node-8201-r2 | 78161e1dbafe | 8201-32fh-clab:7.9.1 | linux | running | 172.20.6.102/24 | 2001:172:20:6::102/80 |
| 3 | clab-4-node-8201-r3 | 471943ff1519 | 8201-32fh-clab:7.9.1 | linux | running | 172.20.6.103/24 | 2001:172:20:6::103/80 |
| 4 | clab-4-node-8201-r4 | e45359c0961f | 8201-32fh-clab:7.9.1 | linux | running | 172.20.6.104/24 | 2001:172:20:6::104/80 |
+---+---------------------+--------------+----------------------+-------+---------+-----------------+-----------------------+

9.  Give the 8201 emulator instances 10-12 minutes to come up and be responsive. Monitor progress using docker logs commands:

   ```
   docker logs -f clab-4-node-8201-r1
   ```

If the emulator build is successful the last few entries of docker logs will look like this:

   ```
   02:41:52 INFO R0:found 32 FourHundredGigE interfaces (as expected)
   02:41:52 INFO R0:found all interfaces
   02:41:52 INFO R0:loading config from /mnt/pacific/iosxr_config.txt cvac file.
   02:42:26 INFO R0:applying XR config
   02:42:30 INFO Sim up
   Router up
   ```

10. ssh to c8201 routers:
   ```
   ssh cisco@172.20.6.101
   ssh cisco@172.20.6.102
   ssh cisco@172.20.6.103
   ssh cisco@172.20.6.104
   pw = cisco123
   ```

11. We can also use docker exec to access the routers' console port, or invoke XR cli:

   ```
   docker exec -it clab-4-node-8201-r1 telnet 0 60000
   docker exec -it clab-4-node-8201-r1 /pkg/bin/xr_cli.sh
   ```
