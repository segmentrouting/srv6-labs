kubeadm init --pod-network-cidr=10.142.0.0/16,2001:db8:142:0::/56 --service-cidr=10.96.0.0/16,2001:db8:42:1::/112


### install
1. helm install
```
helm install cilium isovalent/cilium --version 1.15.6 --namespace kube-system -f cilium-enterprise-values.yaml
```

2. verify install
```
kubectl get ds -n kube-system cilium
```

3. add helm srv6
```
helm upgrade -f helm-srv6.yaml cilium isovalent/cilium -n kube-system
```

4. verify helm upgrade
```
helm get values cilium -n kube-system
```

5. apply cilium srv6 bgp
```
kubectl apply -f cilium-srv6-bgp.yaml 
```

6. verify bgp peering
```
cilium bgp peers
```



kubectl annotate node j-cluster00-node00 cilium.io/bgp-virtual-router.65142="router-id=10.42.1.2"

kubectl -n kube-system cilium-l2lkp logs | grep bgp-control-plane
