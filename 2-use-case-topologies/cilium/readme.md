## Cilium SRv6 L3VPN with Nexus 9000v fabric

Dependencies:
 - containerlab
 - kvm/virsh

1. create VM bridges
```
cd config
virsh net-define k8s-cp-net.xml
virsh net-start k8s-cp
virsh net-define k8s-wkr00-net.xml
virsh net-start k8s-wkr00
virsh net-define k8s-wkr01-net.xml
virsh net-start k8s-wkr01
```

2. create VMs
```



k8s worker nodes:
```
sudo vi /etc/default/kubelet
```
```
KUBELET_EXTRA_ARGS="--node-ip=fc00:0:1002::2"
```
```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```



