### General KNE Instructions
These instructions roughly apply to all Starter scenarios when running in KNE

The SRv6-labs work using KNE has been tested on Ubuntu 20.04 bare metal

"KNE is a Google initiative to develop tooling for quickly setting up topologies of containers running various device OSes."

1. Installation and setup instructions:
https://github.com/openconfig/kne/tree/main/docs

2. When importing xrd docker images into KNE/Kind cluster, KNE is expecting a specific image tag.  Example:

   ```
   docker tag ios-xr/xrd-control-plane:7.8.1 xrd:latest
   ```

2. Then Kind load:
   
   ```
   kind load docker-image xrd:latest --name=kne
   ```

3. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
   ```
   echo "kernel.pid_max=1048575" >> /etc/sysctl.conf
   ```
   Then reset sysctl: 
   ```
   sudo sysctl -p
   ```

4. Edit kne-4-node.pb.txt or create a new pb.txt file as needed

5. Deploy KNE topology
   ```
   
   ```


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
