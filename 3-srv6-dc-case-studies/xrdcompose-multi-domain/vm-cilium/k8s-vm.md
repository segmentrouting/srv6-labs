1. Add proxy settings to /etc/environment if needed

```
http_proxy=http://myproxy.com:8080
https_proxy=http://myproxy.com:8080
ftp_proxy=http://myproxy.com:8080
all_proxy=http://myproxy.com:8080
no_proxy=localhost,127.0.0.1,.cisco.com,.gspie.lab,10.200.96.74,10.200.96.120,mirror1,10.200.99.3,10.200.99.7,10.0.0.0/8,192.168.122.12,10.96.0.0/16,10.96.0.1
```
2. Logout and log back in

3. Disable swap
```
sudo swapoff -a 
sudo rm /swap.img
sudo vi /etc/fstab
  comment out the /swap.img line
```

4. If using Calico-VPP, edit netplan to add a VPP interface /etc/netplan/00-installer-config.yaml

```
network:
  ethernets:
    ens7:
      addresses:
        - 10.101.1.3/24
        - fc00:0:101:1::3/64
      routes:
        - to: 10.0.0.0/24
          via: 10.101.1.2
        - to: fc00:0000::/32
          via: fc00:0:101:1::2
        - to: 2001:420:ffff::/48
          via: fc00:0:101:1::2

```
5. sudo netplan apply

6. Install containerd
```
sudo apt install containerd
```

7. Containerd proxy setings (if needed)
```
sudo mkdir /etc/systemd/system/containerd.service.d
sudo vi /etc/systemd/system/containerd.service.d/http-proxy.conf

Add this:

[Service]
Environment="http_proxy=http://myproxy.com:8080" 
Environment="https_proxy=http://myproxy.com:8080" 
Environment="no_proxy=localhost,127.0.0.1,127.0.0.0/8,10.96.0.0/16"
```

8. Restart containerd
```
sudo systemctl daemon-reload
sudo systemctl restart containerd

systemctl show --property=Environment containerd
```

9. Install k8s/kubeadm: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

10. Start kubeadm :

```
sudo kubeadm init
```
 - if kubeadm init fails try removing /etc/containerd/config.toml

11. Install CNI. Calico option: https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises

```
curl https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/calico.yaml -O

kubectl apply -f calico.yaml
```

12. Wait for calico node to complete its init steps:

```
brmcdoug@ubuntu20-vm1:~$ kubectl get all -A
NAMESPACE     NAME                                           READY   STATUS              RESTARTS   AGE
kube-system   pod/calico-kube-controllers-798cc86c47-dczh4   0/1     ContainerCreating   0          106s
kube-system   pod/calico-node-bnx58                          0/1     Init:2/3            0          106s
--------------
brmcdoug@ubuntu20-vm1:~$ kubectl get all -A
NAMESPACE     NAME                                           READY   STATUS              RESTARTS   AGE
kube-system   pod/calico-kube-controllers-798cc86c47-dczh4   0/1     ContainerCreating   0          2m11s
kube-system   pod/calico-node-bnx58                          0/1     Running             0          2m11s

```

13. Untaint the node if you plan to run workload containers on it

```
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

------------

brmcdoug@ubuntu20-vm1:~$ kubectl get nodes -o wide
NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
ubuntu20-vm1   Ready    control-plane   27m   v1.25.4   192.168.122.23   <none>        Ubuntu 20.04.1 LTS   5.4.0-122-generic   containerd://1.5.9

```

14. Deploy K8s workloads (Jalapeno example)
```
git clone https://github.com/cisco-open/jalapeno.git
cd jalapeno/install/
./deploy_jalapeno.sh 
kubectl get pods -A
```

#### Horrible hack for additional proxy issues:

If the pods are stuck in 'container creating' its probably because Containerd doesn't appear to understand the no_proxy env variable and calls to calico are going to the proxy:

Truncated output of kubectl describe pod:
```
  Warning  FailedCreatePodSandBox  76s (x5 over 10m)  kubelet            (combined from similar events): Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "d632669836fff0b389d0036517590256d14a8181fe384f5bedbe9c5befaf3b20": error getting ClusterInformation: Get "https://10.96.0.1:443/apis/crd.projectcalico.org/v1/clusterinformations/default": context deadline exceeded
```
Containerd env (note there isn't a no_proxy)
```
systemctl show --property=Environment containerd

Environment=http_proxy=http://myproxy.com:8080 https_proxy=http://myproxy.com:8080
```

1. Disable containerd proxy settings:

```
sudo mv /etc/systemd/system/containerd.service.d/http-proxy.conf ~/

sudo systemctl daemon-reload
sudo systemctl restart containerd
```

Calico calls are now working, however, images won't pull because Containerd is no longer using the proxy for http downloads. Truncated output of describe pod:

```
  Warning  Failed                  11m                  kubelet            Failed to pull image "influxdb:1.7-alpine": rpc error: code = Unknown desc = failed to pull and unpack image "docker.io/library/influxdb:1.7-alpine": failed to resolve reference "docker.io/library/influxdb:1.7-alpine": failed to do request: Head https://registry-1.docker.io/v2/library/influxdb/manifests/1.7-alpine: dial tcp 44.205.64.79:443: i/o timeout
```
2. So we re-enable to friggin proxy:
```
sudo mv http-proxy.conf /etc/systemd/system/containerd.service.d/

sudo systemctl daemon-reload
sudo systemctl restart containerd
```
3. And hopefully images download and start:
```
kubectl get pods -A
NAMESPACE             NAME                                           READY   STATUS    RESTARTS      AGE
jalapeno              arangodb-0                                     1/1     Running   0             89m
jalapeno              grafana-deployment-565756bd74-hfkl2            1/1     Running   0             89m
```