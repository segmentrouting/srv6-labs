### reference: https://thenewstack.io/how-to-deploy-kubernetes-with-kubeadm-and-containerd/

These instructions have been verified on Ubuntu 20.04 and 22.04

1. turn off swap and set data/time:
```
sudo timedatectl set-timezone America/Los_Angeles
sudo swapoff -a
sudo rm /swap.img
```

2. Edit /etc/fstab, comment out swap
3. apt update/upgrade
```
sudo apt update 
sudo apt upgrade -y
```

4. add curl/https packages, keys, etc.
```
sudo apt install curl apt-transport-https -y
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list 
sudo apt update
```

5. apt install kubernetes:
``` 
sudo apt -y install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

6. enable kubelet, modprobes:
```
sudo systemctl enable --now kubelet
sudo modprobe overlay
sudo modprobe br_netfilter
```
7. edit sysctl.conf
```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
```
```
sudo sysctl -p
```

7. install containerd and runc
```
wget https://github.com/containerd/containerd/releases/download/v1.7.19/containerd-1.7.19-linux-amd64.tar.gz 
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo tar Cxzvf /usr/local containerd-1.7.19-linux-amd64.tar.gz 

sudo cp containerd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

sudo systemctl status containerd

wget https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.amd64
sudo  install -m 755 runc.amd64 /usr/local/sbin/runc
```

8. You may now initialize your k8s cluster with kubeadm init [reference](../readme.md#initialize-the-kubernetes-cluster)