### Procedure to setup BGP ip numbered SRv6 L3VPN 

1. configure VRF on sonic linux
```
sudo config vrf add Vrf1
sudo config interface vrf bind Ethernet16 Vrf1
```
2. apply sysctl vrf strict mode setting
```
admin@sonic01:~$ tail -f /etc/sysctl.conf 
net.ipv6.conf.eth0.keep_addr_on_down = 1
net.ipv4.tcp_l3mdev_accept = 1
net.ipv4.udp_l3mdev_accept = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.somaxconn = 512
net.ipv4.fib_multipath_use_neigh = 1

net.vrf.strict_mode = 1     <------------
```
3. reset sysctl
```
sudo sysctl -p
```
4. configure frr 
5. cleanout stuff that frr puts in there by default (hopefully this step won't be required much longer, see Bug note below):
```
no ip prefix-list PL_LoopbackV4 seq 5 permit 10.1.0.1/32
no route-map RM_SET_SRC6 permit 10
no route-map RM_SET_SRC permit 10
no ip protocol bgp route-map RM_SET_SRC
no ipv6 protocol bgp route-map RM_SET_SRC6

no bgp community-list standard allow_list_default_community seq 5 permit no-export
no bgp community-list standard allow_list_default_community seq 10 permit 5060:12345
no route-map ALLOW_LIST_DEPLOYMENT_ID_0_V4 permit 65535
no route-map ALLOW_LIST_DEPLOYMENT_ID_0_V6 permit 65535
no route-map FROM_BGP_PEER_V4 permit 10
no route-map FROM_BGP_PEER_V4 permit 11
no route-map FROM_BGP_PEER_V4 permit 100
no route-map FROM_BGP_PEER_V6 permit 1
no route-map FROM_BGP_PEER_V6 permit 10
no route-map FROM_BGP_PEER_V6 permit 11
no route-map FROM_BGP_PEER_V6 permit 100
no route-map TO_BGP_PEER_V4 permit 100
no route-map TO_BGP_PEER_V6 permit 100
```
6. if necessary fix bgp vpn RT settings (same note about Bug)
```
router bgp 65001 vrf Vrf1
 address-family ipv4 unicast
 rd vpn export 10.0.0.1:1
 rt vpn both 1:1
 exit-address-family
 address-family ipv6 unicast
 rd vpn export 10.0.0.1:1
 rt vpn both 1:1
```
7. Do 'show ipv6 route' in FRR. If BGP L3VPN SID is 'rejected', restart docker bgp container
Example:
```
B>r fc00:0:2:6500::/128 [20/0] is directly connected, Vrf1, seg6local uDT46 unknown(seg6local_context2str), flavors unknown(seg6local_context2str), seg6 ::, weight 1, 01:44:25
```
```
docker restart bgp
```
Now it should show something like:
```
sonic02# show ipv6 route
Codes: K - kernel route, C - connected, S - static, R - RIPng,
       O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
       v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

B>* fc00:0:1::/48 [20/0] via fc00:0:ffff::11, Ethernet4, weight 1, 00:09:49
B>* fc00:0:1::1/128 [20/0] via fc00:0:ffff::11, Ethernet4, weight 1, 00:09:49
S>* fc00:0:2::/48 [1/0] is directly connected, Loopback0, weight 1, 00:09:57
C>* fc00:0:2::1/128 is directly connected, Loopback0, 00:09:59
B>* fc00:0:2:6500::/128 [20/0] is directly connected, Vrf1, seg6local uDT46 unknown(seg6local_context2str), flavors unknown(seg6local_context2str), seg6 ::, weight 1, 00:09:54
```
8. Check sonic linux routes
```
admin@sonic01:~$ ip route show vrf Vrf1
10.10.101.0/24 dev Ethernet16 proto kernel scope link src 10.10.101.1 
10.10.201.0/24 nhid 233  encap seg6 mode encap segs 1 [ fc00:0:2:6500:: ] via inet6 fc00:0:ffff::3 dev Ethernet4 proto bgp metric 20 
```
9. Verify dataplane using tcpdump on sonic linux; example sonic PE egress interface:
```
admin@sonic01:~$ sudo tcpdump -ni Ethernet4
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on Ethernet4, link-type EN10MB (Ethernet), snapshot length 262144 bytes

04:51:54.905226 IP6 fe80::5054:ff:fe74:c104 > ff02::1: ICMP6, router advertisement, length 56
04:51:56.262226 IP6 fc00:0:1::1 > fc00:0:2:6500::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:2:6500::) IP 10.10.101.2 > 10.10.201.1: ICMP echo request, id 6248, seq 1, length 76
04:51:56.265307 IP6 fc00:0:2::1 > fc00:0:1:6500::: RT6 (len=2, type=4, segleft=0, last-entry=0, tag=0, [0]fc00:0:1:6500::) IP 10.10.201.1 > 10.10.101.2: ICMP echo reply, id 6248, seq 1, length 76
```

### Notes:

1. Bug: change to sonic/linux vrf IP results in FRR changing the vrf RT export values, thus breaking remote vrf RT imports
2. Bug: changes to sonic/linux config results in FRR re-adding the route-maps, etc. listed in step 5 above