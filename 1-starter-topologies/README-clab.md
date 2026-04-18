### General Containerlab Instructions

**Conventions in this repo:** XRd labs use image `ios-xr/xrd-control-plane:25.4.2`, management IPv4 only (no management IPv6 in the topology files), and `prefix: ""` so container names are `{lab-name}-{node-name}` instead of the default `clab-{lab-name}-{node-name}`.

These instructions roughly apply to all Starter topologies when running Containerlab
   
1. Requirements: Openvswitch
   ```
   sudo apt-get install openvswitch-switch -y
   ```
   
2. Install containerlab: https://containerlab.dev/install/

   Or the quick and easy way:
   ```
   bash -c "$(curl -sL https://get.containerlab.dev)"
   ```

3. Acquire/download and untar router image(s). XRd example:
   
   #### XRd:
   https://xrdocs.io/virtual-routing/tutorials/2022-08-22-xrd-images-where-can-one-get-them/
   https://software.cisco.com/download/home/286331236/type/280805694/release


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
     
6. Validate KVM modules are installed and configured:
   ```
   file /dev/kvm
   ```
   output should look something like:
   ```
   brmcdoug@dev7:~$ file /dev/kvm
   /dev/kvm: character special (10/232)
   ```
7. Optional: XRd generally requires 2GB of memory and is fairly light on CPU. Run the 'host-check' script to get a sense for how many XRd instances you can run on your host/VM: 

    https://github.com/segmentrouting/srv6-labs/blob/main/utils/host-check

8.  Change directory to the location of the topology you wish to work with
    Example: 
    ```
    cd srv6-labs/1-starter-topologies/xrd
    ```
   
9.  Deploy topology
    ```
    sudo containerlab deploy -t clab-4-node-xrd.yml
    ```

#### Example terminal output
```
brmcdoug@dev7:~/srv6-labs/1-starter-topologies/xrd$ sudo containerlab deploy -t clab-4-node-xrd.yml
INFO[0000] Containerlab v0.48.6 started                 
INFO[0000] Parsing & checking topology file: clab-4-node-xrd.yml 
INFO[0000] Creating docker network: Name="mgt_net", IPv4Subnet="172.20.1.0/24", MTU='...' 
INFO[0000] Creating lab directory: .../1-starter-topologies/xrd/4-node 
INFO[0000] Creating container: "xrd03"                  
INFO[0000] Creating container: "xrd02"                  
INFO[0000] Creating container: "xrd01"                  
INFO[0000] Creating container: "xrd04"                  
INFO[0003] Creating link: xrd01:Gi0-0-0-1 <--> xrd04:Gi0-0-0-0 
INFO[0004] Creating link: xrd01:Gi0-0-0-0 <--> xrd03:Gi0-0-0-0 
INFO[0004] Creating link: xrd03:Gi0-0-0-2 <--> xrd04:Gi0-0-0-2 
INFO[0004] Creating link: xrd02:Gi0-0-0-0 <--> xrd03:Gi0-0-0-1 
INFO[0005] Creating link: xrd02:Gi0-0-0-1 <--> xrd04:Gi0-0-0-1 
INFO[0005] Creating link: xrd01:Gi0-0-0-2 <--> xrd01-host:xrd01-Gi0-0-0-2 
INFO[0005] Creating link: xrd02:Gi0-0-0-2 <--> xrd02-host:xrd02-Gi0-0-0-2 
INFO[0006] Adding containerlab host entries to /etc/hosts file 
INFO[0006] Adding ssh config for containerlab nodes     
+---+-------------------+--------------+------------------------------------+-----------+---------+-----------------+
| # |       Name        | Container ID |               Image                |   Kind    |  State  |  IPv4 Address   |
+---+-------------------+--------------+------------------------------------+-----------+---------+-----------------+
| 1 | 4-node-xrd01      | ...          | ios-xr/xrd-control-plane:25.4.2   | cisco_xrd | running | 172.20.1.101/24 |
| 2 | 4-node-xrd02      | ...          | ios-xr/xrd-control-plane:25.4.2   | cisco_xrd | running | 172.20.1.102/24 |
| 3 | 4-node-xrd03      | ...          | ios-xr/xrd-control-plane:25.4.2   | cisco_xrd | running | 172.20.1.103/24 |
| 4 | 4-node-xrd04      | ...          | ios-xr/xrd-control-plane:25.4.2   | cisco_xrd | running | 172.20.1.104/24 |
+---+-------------------+--------------+------------------------------------+-----------+---------+-----------------+
```

10.  Give the XRd instances 2-3 minutes to come up and be responsive. All the usual docker commands work:

#### check status of instances:
```
docker ps
docker logs -f 
```
#### docker exec access to xr cli:
```
docker exec -it 4-node-xrd01 /pkg/bin/xr_cli.sh
```

11. ssh to routers
```
xrd01:
ssh cisco@172.20.1.101

xrd02:
ssh cisco@172.20.1.102

xrd03:
ssh cisco@172.20.1.103

xrd04:
ssh cisco@172.20.1.104

pw for all = cisco123
```

12.  To shutdown or destroy the topology (with -c to cleanup files/logs/etc.):
    ```
    sudo containerlab destroy -t clab-4-node-xrd.yml -c 
    ```

## Appendix

### Containerlab interconnecting a topology across multiple hosts or host VMs
https://containerlab.dev/lab-examples/multinode/#vxlan-tunneling

The 2-node-vxlan yaml files in this directory will create the equivalent of the 4-node topology but spread across a pair of hosts or host-VMs using containerlab's vxlan tunneling utility.

1. Follow the same instructions as above for loading images, etc.
   
2. Deploy the two yamls on two separate hosts/VMs which have IP reachability to one another
   Host A:
   ```
   sudo containerlab deploy -t clab-2-node-vxlan-a.yml
   ```
   Host B:
   ```
   sudo containerlab deploy -t clab-2-node-vxlan-b.yml
   ```

3. create the vxlan tunnels on Host A (replace IP 198.18.133.101 with Host B's IP):

   Host A:
   ```
   sudo clab tools vxlan create --remote 198.18.133.101 --id 10 --link xrd01-Gi0-0-0-1
   sudo clab tools vxlan create --remote 198.18.133.101 --id 20 --link xrd03-Gi0-0-0-1
   ```

4. create the vxlan tunnels on Host B (replace IP 198.18.133.100 with Host A's IP):

   Host B:
   ```
   sudo clab tools vxlan create --remote 198.18.133.100 --id 10 --link xrd04-Gi0-0-0-0
   sudo clab tools vxlan create --remote 198.18.133.100 --id 20 --link xrd02-Gi0-0-0-0
   ```

5. This also works over an IPv6 host-to-host network:

   Host A:
   ```
   sudo clab tools vxlan create --remote 2001:db8:1:1::2 --id 10 --link xrd01-Gi0-0-0-1
   sudo clab tools vxlan create --remote 2001:db8:1:1::2 --id 20 --link xrd03-Gi0-0-0-1
   ```

   Host B:
   ```
   sudo clab tools vxlan create --remote 2001:db8:1:1::1 --id 10 --link xrd04-Gi0-0-0-0
   sudo clab tools vxlan create --remote 2001:db8:1:1::1 --id 20 --link xrd02-Gi0-0-0-0
   ```

6. With IPv6 vxlan tunnels in place the hosts' NIC/vNIC will need their MTU bumped up higher than 1500 for the routers to form ISIS adjacencies:

   ```
   sudo ip link set dev ens192 mtu 3000
   ```
