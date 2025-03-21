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



Verification:
```
kubectl get ds -n kube-system cilium

cilium bgp peers

kubectl get sidmanager -o yaml
kubectl get sidmanager -o custom-columns="NAME:.metadata.name,ALLOCATIONS:.spec.locatorAllocations"

kubectl get sidmanager k8s-wkr00-22 -o yaml
kubectl get sidmanager k8s-wkr01-22 -o yaml

kubectl describe pod -n blue blue0
kubectl describe pod -n blue blue1
kubectl describe pod -n green green0

kubectl describe pod -n blue blue0 | grep -e Node -e vrf -e IP
kubectl describe pod -n blue blue1 | grep -e Node -e vrf -e IP
kubectl describe pod -n green green0 | grep -e Node -e vrf -e IP

cilium bgp routes advertised ipv4 mpls_vpn 
cilium bgp routes available ipv4 mpls_vpn

kubectl get isovalentvrf -o yaml

kubectl get IsovalentSRv6EgressPolicy
```
### eBPF
```
kubectl get pods -n kube-system | grep cilium
```

Get local SID table
```
kubectl exec -n kube-system cilium-86cbn -- cilium-dbg bpf srv6 sid
kubectl exec -n kube-system cilium-whzn6 -- cilium-dbg bpf srv6 sid
kubectl exec -n kube-system cilium-vnk96 -- cilium-dbg bpf srv6 sid
```

Get SRv6 VRF table
```
kubectl exec -n kube-system cilium-86cbn -- cilium-dbg bpf srv6 vrf
kubectl exec -n kube-system cilium-whzn6 -- cilium-dbg bpf srv6 vrf
kubectl exec -n kube-system cilium-vnk96 -- cilium-dbg bpf srv6 vrf
```

Get SRv6 Egress Policy
```
kubectl exec -n kube-system cilium-86cbn -- cilium-dbg bpf srv6 policy
kubectl exec -n kube-system cilium-whzn6 -- cilium-dbg bpf srv6 policy
kubectl exec -n kube-system cilium-vnk96 -- cilium-dbg bpf srv6 policy
```
