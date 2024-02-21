## CLAB CLOS

The CLOS topology is designed such that it could scale out massively (per the diagram: 96 bricks, 1024 spine nodes, etc.). Currently the topology files define 16 Spine nodes and three 4x4 Bricks to be spread across a pair of hosts or VMs (recommend minimum of 32 vCPU and 64GB memory): 

* clos-upper.yml - 16 spine nodes and brick 0 nodes (see topology diagram)
* clos-lower.yml - bricks 1 and 2

The topology leverages containerlab's multi-host tool which interconnects the topology across hosts via VXLAN tunnels.

To launch the topology run the following across a pair of hosts or VMs:

#### "Upper" Host or VM:
```
./add-upper-bridges.sh
sudo containerlab deploy -t clos-upper.yml
./vxlan-upper.sh
```

#### "Lower" Host or VM:
```
./add-lower-bridges.sh
sudo containerlab deploy -t clos-lower.yml
./vxlan-lower.sh
```

![Topology](clos-diagram.png)