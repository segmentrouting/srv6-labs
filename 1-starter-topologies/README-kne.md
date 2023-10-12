## Under construction as of 10/11/2023

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

4. Verify image is loaded:
   ```
   docker exec -it kne-control-plane crictl images
   ```
   Example:
   ```
   docker.io/library/8000e          latest           4cd1c6e59a5d3       6.37GB
   ```

5. Edit kne-4-node.pb.txt or create a new pb.txt file as needed

6. Deploy KNE topology
   ```
   kne create kne-4-node-xrd.pb.txt 
   ```

#### Example truncated KNE deploy terminal output

brmcdoug@naja:~/srv6-labs/1-starter-topologies/xrd$ kne create kne-4-node-xrd.pb.txt 
<snip>
I1011 03:34:39.183264   15449 cisco.go:195] Created Cisco xrd node resource xrd04 pod
I1011 03:34:39.486990   15449 cisco.go:199] Created Cisco xrd node resource xrd04 services
I1011 03:34:39.487040   15449 topo.go:559] Node "xrd04" (vendor: "CISCO", model: "xrd") resource created
I1011 03:34:47.331001   15449 cisco.go:484] Cisco xrd node xrd02 status is RUNNING 
I1011 03:34:47.331061   15449 topo.go:625] Node "xrd02" (vendor: "CISCO", model: "xrd"): Status RUNNING
I1011 03:34:48.213310   15449 cisco.go:484] Cisco xrd node xrd01 status is RUNNING 
I1011 03:34:48.213346   15449 topo.go:625] Node "xrd01" (vendor: "CISCO", model: "xrd"): Status RUNNING
I1011 03:34:49.413628   15449 cisco.go:484] Cisco xrd node xrd04 status is RUNNING 
I1011 03:34:49.413673   15449 topo.go:625] Node "xrd04" (vendor: "CISCO", model: "xrd"): Status RUNNING
I1011 03:34:50.225147   15449 cisco.go:484] Cisco xrd node xrd03 status is RUNNING 
I1011 03:34:50.225192   15449 topo.go:625] Node "xrd03" (vendor: "CISCO", model: "xrd"): Status RUNNING
I1011 03:34:50.325717   15449 topo.go:273] Topology "xrd-4-node" created
Log files can be found in:
    /tmp/kne.naja.brmcdoug.log.INFO.20231011-033437.15449

7. Check containers:
   ```
   kubectl get pods -n xrd-4-node
   kubectl logs -n xrd-4-node xrd01
   ```
   Example:
   ```
   brmcdoug@naja:~/srv6-labs/1-starter-topologies/xrd$ kubectl get pods -n xrd-4-node
   NAME    READY   STATUS    RESTARTS   AGE
   xrd01   1/1     Running   0          3m18s
   xrd02   1/1     Running   0          3m18s
   xrd03   1/1     Running   0          3m17s
   xrd04   1/1     Running   0          3m16s
   ```

#### To delete KNE topology:
```
kne delete kne-4-node-xrd.pb.txt 
```


