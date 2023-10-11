10/8/23 - SRv6 KNE lab using 8000e is under construction

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

### KNE installation and topology deployment instructions: 

The SRv6-labs work using KNE has been tested on Ubuntu 20.04 bare metal

"KNE is a Google initiative to develop tooling for quickly setting up topologies of containers running various device OSes."

1. Installation and setup instructions:
https://github.com/openconfig/kne/tree/main/docs

2. When importing c8000 docker images into KNE/Kind cluster, KNE is expecting a specific image tag.  Example:

   ```
   docker tag 8201-32fh-kne:7.9.1 8000e:latest
   ```

3. Then Kind load:
   
   ```
   kind load docker-image 8000e:latest --name=kne
   ```

4. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
   ```
   echo "kernel.pid_max=1048575" >> /etc/sysctl.conf
   ```
   Then reset sysctl: 
   ```
   sudo sysctl -p
   ```

5. Edit kne-4-node.pb.txt or create a new pb.txt file as needed

#### Example KNE deploy terminal output



If the emulator build is successful the last few entries of docker logs will look like this:

   ```
   02:41:52 INFO R0:found 32 FourHundredGigE interfaces (as expected)
   02:41:52 INFO R0:found all interfaces
   02:41:52 INFO R0:loading config from /mnt/pacific/iosxr_config.txt cvac file.
   02:42:26 INFO R0:applying XR config
   02:42:30 INFO Sim up
   Router up
   ```

1.  ssh to c8201 routers:
   ```
   ssh cisco@172.20.6.101
   ssh cisco@172.20.6.102
   ssh cisco@172.20.6.103
   ssh cisco@172.20.6.104
   pw = cisco123
   ```

2.  We can also use docker exec to access the routers' console port, or invoke XR cli:

   ```
   docker exec -it clab-4-node-8201-r1 telnet 0 60000
   docker exec -it clab-4-node-8201-r1 /pkg/bin/xr_cli.sh
   ```
