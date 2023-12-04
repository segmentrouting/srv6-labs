10/8/23 - SRv6 KNE lab using 8000e is under construction

## Cisco 8000 hardware emulator (8000e) using KNE

The kne-4-node.yml launches a 4-node 8201-32FH emulator topology using KNE. The nodes get their configurations from those in the local config directory. In the provided example each node is dual connected to its neighbor per the topology diagram (single links shown):
 
####  r02---r03
####   | \  / |
####   |  \/  |
####   |  /\  |
####   | /  \ |
####  r00    r01

The sample 4-node topology in this repo consists of 4 emulated Cisco 8201-32FH nodes whose configurations are found in the *config* directory. The nodes are configured with basic ISIS, SR, SRv6, iBGP and streaming telemetry. 8201-r3 is a route-reflector with the other 3 nodes as clients. 

Please feel free to use this topology or add additional topologies and configurations, etc.

[KNE Install Instructions](../README-kne.md)

1. Acquire 8000e KNE image - contact Cisco account team to get access to Cisco 8000 KNE docker images
2. Docker load image
   ```
   docker load -i 8101-32h_kne_206_latest.tar.gz 
   ```

3. Tag the c8000 docker images into KNE/Kind cluster, KNE is expecting a specific image tag.  Example:

   ```
   docker tag 8101-32h_206:latest 8000e:latest
   ```

4. Then Kind load:
   
   ```
   kind load docker-image 8000e:latest --name=kne
   ```

5. Verify image is loaded:
   ```
   docker exec -it kne-control-plane crictl images
   ```
   Example:
   ```
   docker.io/library/8000e          latest           4cd1c6e59a5d3       6.37GB
   ```
6. Edit /etc/sysctl.conf and increase kernel.pid_max parameter:
   ```
   echo "kernel.pid_max=1048575" >> /etc/sysctl.conf
   ```
   Then reset sysctl: 
   ```
   sudo sysctl -p
   ```

7. Verify image is loaded:
   ```
   docker exec -it kne-control-plane crictl images
   ```
   Example:
   ```
   docker.io/library/8000e          latest           4cd1c6e59a5d3       6.37GB
   ```

8. Edit kne-4-node.pb.txt or create a new pb.txt file as needed

9. Deploy KNE topology
   ```
   kne create kne-4-node-8000e.pb.txt 
   ```

#### Example KNE deploy terminal output



7. Check containers:
   ```
   kubectl get pods -n xrd-4-node
   kubectl logs -n xrd-4-node xrd01
   ```
   Example: