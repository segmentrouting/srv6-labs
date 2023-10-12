### General Containerlab Instructions
These instructions roughly apply to all Starter scenarios when running in Containerlab
   
1. Requirements: Openvswitch
   ```
   sudo apt-get install openvswitch-switch -y
   ```
   
2. Install containerlab: https://containerlab.dev/install/
   Or the quick and easy way:
   ```
   bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.40.0
   ```

3. Acquire dockerized router image(s):
   
   #### XRd:
   https://xrdocs.io/virtual-routing/tutorials/2022-08-22-xrd-images-where-can-one-get-them/
   https://software.cisco.com/download/home/286331236/type/280805694/release

   #### 8000e
   Not yet available on public download; contact Cisco

4. Load docker image(s):
```
docker load -i xrd-control-plane-container-x64.dockerv1.tgz 
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
   /dev/kvm: character special (10/232)
   ```
7. Optional: XRd generally requires 2GB of memory and is fairly light on CPU. Run the 'host-check' script to get a sense for how many XRd instances you can run on your host/VM: 

     https://github.com/segmentrouting/srv6-labs/blob/main/utils/host-check

8.  Change directory to the location of the topology you wish to work with
    Example: 
    ```
    cd srv6-labs/1-starter-topologies-xrd
    ```
   
9.  Deploy topology
    ```
    sudo containerlab deploy -t clab-4-node-xrd.yml
    ```

#### Example terminal output
brmcdoug@ie-dev7:~/srv6-labs/clab-quickstart$ sudo containerlab deploy -t 4-node-quickstart.yml
INFO[0000] Containerlab v0.40.0 started                 
INFO[0000] Parsing & checking topology file: 4-node-quickstart.yml 
INFO[0000] Creating lab directory: /home/brmcdoug/srv6-labs/clab-quickstart/clab-4-node 
INFO[0000] Creating docker network: Name="mgt_net", IPv4Subnet="172.20.1.0/24", IPv6Subnet="2001:172:20:1::/80", MTU="1500" 
INFO[0000] Creating container: "xrd03"                  
INFO[0000] Creating container: "xrd02"                  
INFO[0000] Creating container: "xrd01"                  
INFO[0000] Creating container: "xrd00"                  
INFO[0005] Creating virtual wire: xrd01:Gi0-0-0-1 <--> xrd03:Gi0-0-0-1 
INFO[0005] Creating virtual wire: xrd00:Gi0-0-0-1 <--> xrd03:Gi0-0-0-0 
INFO[0005] Creating virtual wire: xrd01:Gi0-0-0-0 <--> xrd02:Gi0-0-0-1 
INFO[0005] Creating virtual wire: xrd00:Gi0-0-0-0 <--> xrd02:Gi0-0-0-0 
INFO[0005] Creating virtual wire: xrd02:Gi0-0-0-2 <--> xrd03:Gi0-0-0-2 
INFO[0006] Adding containerlab host entries to /etc/hosts file 
INFO[0006] 🎉 New containerlab version 0.45.1 is available! Release notes: https://containerlab.dev/rn/0.45/#0451
Run 'containerlab version upgrade' to upgrade or go check other installation options at https://containerlab.dev/install/ 
+---+-------------------+--------------+--------------------------------+-----------+---------+-----------------+-----------------------+
| # |       Name        | Container ID |             Image              |   Kind    |  State  |  IPv4 Address   |     IPv6 Address      |
+---+-------------------+--------------+--------------------------------+-----------+---------+-----------------+-----------------------+
| 1 | clab-4-node-xrd00 | e6b6c1095560 | ios-xr/xrd-control-plane:7.9.2 | cisco_xrd | running | 172.20.1.100/24 | 2001:172:20:1::100/80 |
| 2 | clab-4-node-xrd01 | ad061c7fd1e5 | ios-xr/xrd-control-plane:7.9.2 | cisco_xrd | running | 172.20.1.101/24 | 2001:172:20:1::101/80 |
| 3 | clab-4-node-xrd02 | 5ba3f1cea735 | ios-xr/xrd-control-plane:7.9.2 | cisco_xrd | running | 172.20.1.102/24 | 2001:172:20:1::102/80 |
| 4 | clab-4-node-xrd03 | 77830cd8f499 | ios-xr/xrd-control-plane:7.9.2 | cisco_xrd | running | 172.20.1.103/24 | 2001:172:20:1::103/80 |
+---+-------------------+--------------+--------------------------------+-----------+---------+-----------------+-----------------------+


10. Give the XRd instances 2-3 minutes to come up and be responsive. All the usual docker commands work:

#### check status of instances:
```
docker ps
docker logs -f 
```
#### docker exec access to xr cli:
```
docker exec -it clab-xrd-7-node-xrd05 /pkg/bin/xr_cli.sh
```

11. ssh to routers
```
xrd02:
ssh cisco@172.20.1.101

xrd02:
ssh cisco@172.20.1.102

xrd03:
ssh cisco@172.20.1.103

xrd04:
ssh cisco@172.20.1.104

pw for all = cisco123
```