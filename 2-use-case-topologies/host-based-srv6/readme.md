## Host Based SRv6 with Cilium

1. Install containerd and kubeadm/kubelet/kubectl on one or more hosts/VMs
2. Disable swap (rm /swap.img, sudo swapoff, edit /etc/fstab)
3. Install Helm
4. Add helm cilium repo:
```
helm repo add isovalent https://helm.isovalent.com
```

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/dual-stack-support/

5. enable ipv4 and ipv6 forwarding in /etc/sysctl.conf
6. kubeadm init on control plane node:
```
kubeadm init --pod-network-cidr=10.244.0.0/16,2001:db8:42:0::/56 --service-cidr=10.96.0.0/16,2001:db8:42:1::/112
```
or
```
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
networking:
  podSubnet: 10.244.0.0/16,2001:db8:42:0::/56
  serviceSubnet: 10.96.0.0/16,2001:db8:42:1::/112
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "10.42.1.2"
  bindPort: 6443
nodeRegistration:
  kubeletExtraArgs:
    node-ip: 10.42.1.2,fc00:0:42:1::2
```
```
kubeadm init --config=kubeadm-config.yaml
```
7. then on worker node:
```
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
discovery:
  bootstrapToken:
    apiServerEndpoint: 10.42.1.2:6443
    token: "8cqt9p.uiappanc0o127icm"
    caCertHashes:
    - "sha256:806fade2ba9fd925e7388318b7909cf0a9a9c9454a167a29a01c84c8a629ac53"
    # change auth info above to match the actual token and CA certificate hash for your cluster
nodeRegistration:
  kubeletExtraArgs:
    node-ip: 10.43.1.2,fc00:0:43:1::2
```

8. verify nodes:
```
kubectl get nodes -o wide
kubectl describe nodes | grep -E 'InternalIP'
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
kubectl cluster-info dump | grep -m 1 cluster-cidr
ps -ef | grep "cluster-cidr"
```

1.  install cilium with helm 

```
helm install cilium isovalent/cilium --version 1.15.6 -f helm-global-conf.yaml
```

1.   helm upgrade (if making changes)
```
helm upgrade -f helm-global-conf.yaml cilium isovalent/cilium -n kube-system
```

1.   restart cilium operator:
```
kubectl -n kube-system rollout restart ds/cilium
```

1.   helm get values, show node labels
```
helm get values cilium -n kube-system
kubectl get nodes --show-labels=true
```

###    cilium bgp peering

1. bgp yaml
```
apiVersion: "cilium.io/v2alpha1"
kind: CiliumBGPPeeringPolicy
metadata:
  name: pe0
  namespace: kube-system
spec:
  nodeSelector:
    matchLabels:
      kubernetes.io/hostname: j-cluster00-node00
  virtualRouters:
  - localASN: 65142
    exportPodCIDR: true
    mapSRv6VRFs: true
    neighbors:
    - peerAddress: "fc00:0:42:1::1/128"
      peerASN: 65042
      families:
       - afi: ipv4
         safi: mpls_vpn
```

1.  validate BGP



11. deploy a pod:
https://yolops.net/k8s-dualstack-cilium.html

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: nginx-test
  name: nginx-test
spec:
  containers:
  - image: nginx:latest
    name: nginx-test
```

1.  get pods/describe pod, exec into pod
```
kubectl get pods -A
kubectl describe pod nginx-test
kubectl exec -it nginx-test -- bash
```



1.  helm upgrade with this yaml
```
enterprise:
  srv6:
    enabled: true
    locatorPoolEnabled: true
bgpControlPlane:
  enabled: true
ipam:
  mode: cluster-pool
ipv4:
  enabled: true
ipv6:
  enabled: true
```
#### command
```
helm upgrade -f helm-enterprise-srv6.yaml cilium isovalent/cilium -n kube-system
```

1.  helm uninstall
```
helm uninstall cilium isovalent/cilium -n kube-system
```

1.  helm list
```
cisco@j-cluster00-node00:~/helm$ helm list -n kube-system
NAME  	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART        	APP VERSION
cilium	kube-system	3       	2024-06-26 20:47:04.417451988 -0700 PDT	deployed	cilium-1.15.6	1.15.6    
```

1.  configure locator pool (kubectl apply -f "this file")
```
apiVersion: isovalent.com/v1alpha1
kind: IsovalentSRv6LocatorPool
metadata:
  name: pool0
  labels:
    # This label will be used in the next step
    export: "true"
spec:
  behaviorType: uSID
  prefix: fc00:0000:42:1::/64
  structure:
    locatorBlockLenBits: 48
    locatorNodeLenBits: 16
    functionLenBits: 16
    argumentLenBits: 0
```
or
```
apiVersion: isovalent.com/v1alpha1
kind: IsovalentSRv6LocatorPool
metadata:
  name: pool0
  labels:
    # This label will be used in the next step
    export: "true"
spec:
  behaviorType: uSID
  prefix: fc00:0:42::/48
  locatorLenBits: 64 
  structure:
    locatorBlockLenBits: 32
    locatorNodeLenBits: 16
    functionLenBits: 32
    argumentLenBits: 0
```

1.  validate locator pool
```
kubectl get sidmanager -o custom-columns="NAME:.metadata.name,ALLOCATIONS:.spec.locatorAllocations"
```

