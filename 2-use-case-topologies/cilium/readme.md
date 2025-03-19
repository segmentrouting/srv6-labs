## Cilium SRv6 L3VPN with Nexus 9000v fabric

Dependencies:
 - containerlab
 - kvm/virsh

1. create VM bridges
```
cd config
virsh net-define k8s-cp-net.xml
virsh net-start k8s-cp
```

2. create VMs
```
