## Peterson Graph - Work in Progress
![Peterson Graph](diagrams/topology.png)

A containerlab based project with 10 nodes linked together in a Peterson Graph with two iterations:

* SRv6 based
* MPLS-TE/RSVP based

The project also includes an option to deploy containerized TRex traffic generators attached to each router

1. cd into this directory and deploy topology
```
sudo containerlab deploy -t peterson-graph.yml
```

2. deploy Ubuntu TRex containers
```
sudo containerlab deploy -t ubtrex.yml
```

3. 