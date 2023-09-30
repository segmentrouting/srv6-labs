### Containerlab quickstart topologies

Quickly get up and running and working with SRv6 with one of these topologies

Instructions: 

1. Ubuntu 20.04 or 22.04 bare-metal or VM
   
2. Openvswitch
   ```
   sudo apt-get install openvswitch-switch -y
   ```
   
3. Install containerlab: https://containerlab.dev/install/
   Or the quick and easy way:
   ```
   bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.40.0
   ```

4. Acquire router image(s). As of this writing the quickstart is based on XRd.
   https://xrdocs.io/virtual-routing/tutorials/2022-08-22-xrd-images-where-can-one-get-them/
   https://software.cisco.com/download/home/286331236/type/280805694/release

5. Load docker image(s):
```
docker load -i xrd-control-plane-container-x64.dockerv1.tgz 
``` 

6. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
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
     
7. Validate KVM modules are installed and configured:
   ```
   file /dev/kvm
   ```
   output should look something like:
   ```
   brmcdoug@ie-dev8:~$ file /dev/kvm
   /dev/kvm: character special (10/232)
   ```
8. Optional: XRd generally requires 2GB of memory and is fairly light on CPU. Run the 'host-check' script to get a sense for how many XRd instances you can run on your host/VM: 

     https://github.com/segmentrouting/srv6-labs/blob/main/utils/host-check

9.  Modify the quickstart.yml file as needed
   
10.  Deploy topology
    ```
    sudo containerlab deploy -t 4-node-quickstart.yml
    ```

#### Example terminal output

11. Give the XRd instances 2-3 minutes to come up and be responsive. All the usual docker commands work:
```
### check status of instances:
docker ps
docker logs -f 

### docker exec access to xr cli:
docker exec -it clab-xrd-7-node-xrd05 /pkg/bin/xr_cli.sh
```

7. ssh to routers
```
ssh cisco@172.20.5.201
pw = cisco123
```