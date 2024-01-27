## Peterson Graph - Work in Progress
![Peterson Graph](diagrams/topology.png)

A containerlab based project with 10 nodes linked together in a Peterson Graph with two iterations:

* SRv6 based
* MPLS-TE/RSVP based

1. cd into this directory and deploy topology
```
sudo containerlab deploy -t peterson-graph.yml
```

or
```
sudo containerlab deploy -t peterson-graph-rsvp-te.yml
```

### TRex
The project also includes an option to deploy containerized TRex traffic generators attached to each router

1. deploy Ubuntu TRex containers
```
sudo containerlab deploy -t trex.yml
```

2. run Trex setup script to start TRex process inside each container
```
cd trex
./trex-setup.sh
```

3. The TRex directory includes an example imix traffic generation script that leverages TRex's python API and can be launched from the host VM
```
python3 imix-start.py
```

4. Enable ODN steering from sources to xrd01 host prefix by advertising it with extcomm color

```
ssh cisco@clab-peterson-xrd01
```
Apply config:
```
router bgp 65000
 neighbor-group xrd-ipv6-peer
  address-family ipv4 unicast
   route-policy steer out
  !
 !
!
```