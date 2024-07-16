
# Calico VPP
https://docs.tigera.io/calico/latest/getting-started/kubernetes/vpp/getting-started

cat << EOF > /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.accept_dad = 0
net.ipv6.conf.default.accept_dad = 0
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.all.autoconf = 0
net.ipv6.conf.all.accept_ra = 0
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 0
vm.nr_hugepages = 512
EOF

CALICOVPP_INTERFACES: |-
  {
      "uplinkInterfaces": [ { "interfaceName": "eth0" } ]
  }

### GoBGP

cisco@Host-2:~$ kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp global del all
cisco@Host-2:~$ kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp global as 100 router-id 24.1.1.66
cisco@Host-2:~$ kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp global

```
kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp global
```
Output:
```
AS:        100
Router-ID: 24.1.1.66
Listening Port: 179, Addresses: 0.0.0.0, ::
```

```
kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp neighbor add fcbb:bb00:100:2::1 as 100
```
```
cisco@Host-2:~$ kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp neighbor
Peer                AS  Up/Down State       |#Received  Accepted
fcbb:bb00:100:2::1 100 00:00:03 Establ      |        0         0
cisco@Host-2:~$ 

```

```
kubectl -n calico-vpp-dataplane exec -it calico-vpp-node-6dqfm  -c agent -- gobgp global rib add -a ipv6 fcbb:bb00:100:2:a::/80 nexthop fcbb:bb00:100:2::2
```
