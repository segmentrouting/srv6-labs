### Clab XRd

The 7-node topology is based on https://github.com/jalapeno/SRv6_dCloud_Lab

The 22-node topology is a subset of the [clab-sp-core-plus-dc](../clab-sp-core-and-dc/) topology

Both have been tested on Ubuntu 20.04, 22.04

`7-node.yml`, `22-node.yml`, and `22-node-ext.yml` use `prefix: ""`, image `ios-xr/xrd-control-plane:25.4.2`, and IPv4-only management.

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

   - cpu and memory: XRd generally requires 2GB of memory and is fairly light on CPU. Run the 'host-check' script to get a sense for how many XRd instances you can run on your host/VM: 

     [host-check-script](../../utils/host-check)
  

2. Install Containerlab:
```
https://containerlab.dev/install/
```

3. Load XRd docker image:
```
docker load -i xrd-control-plane-container-x64.dockerv1.tgz 
``` 

4. Define/edit topology yml file in this directory 

5. Run run the *xy-node-add-bridges.sh* script prior to launching the topology - this establishes linux bridge instances for attaching external elements to the topology
   
```
sudo ./7-node-add-bridges.sh
```

```
sudo containerlab deploy -t 7-node.yml
```

Example console output

```
brmcdoug@naja:~/srv6-labs/containerlab/xrd$ sudo containerlab deploy -t 7-node.yml 
INFO[0000] Containerlab v0.40.0 started                 
INFO[0000] Parsing & checking topology file: 7-node.yml 
INFO[0000] Creating lab directory: .../xrd-7-node 
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
+---+------------------+--------------+----------------------------------+-----------+---------+-----------------+
| # |      Name        | Container ID |              Image               |   Kind    |  State  |  IPv4 Address   |
+---+------------------+--------------+----------------------------------+-----------+---------+-----------------+
| 1 | xrd-7-node-xrd01 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.201/24 |
| 2 | xrd-7-node-xrd02 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.202/24 |
| 3 | xrd-7-node-xrd03 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.203/24 |
| 4 | xrd-7-node-xrd04 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.204/24 |
| 5 | xrd-7-node-xrd05 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.205/24 |
| 6 | xrd-7-node-xrd06 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.206/24 |
| 7 | xrd-7-node-xrd07 | ...          | ios-xr/xrd-control-plane:25.4.2 | cisco_xrd | running | 172.20.5.207/24 |
+---+------------------+--------------+----------------------------------+-----------+---------+-----------------+
brmcdoug@naja:~/srv6-labs/containerlab/xrd$ 
```

6. Give the XRd instances 2-3 minutes to come up and be responsive. All the usual docker commands work:
```
### check status of instances:
docker ps

### optional: docker exec access to xr cli
```
docker exec -it xrd-7-node-xrd05 /pkg/bin/xr_cli.sh
```

7. ssh to routers
```
ssh cisco@172.20.5.201
pw = cisco123
```