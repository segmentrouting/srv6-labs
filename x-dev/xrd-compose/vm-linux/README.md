### create ubuntu VM for linux SRv6

1. create a copy of ubuntu-vpp.img 
```
sudo cp ubuntu-vpp.img ubuntu-linux-srv6.img
```

2. copy ubuntu-linux-srv6.xml to your KVM host and define the VM
```
sudo virsh define ubuntu-linux-srv6.xml
```

3. start the VM
```
sudo virsh start ubuntu-linux-srv6
```

4. the VM will boot as "ubuntu-vpp", so we need to connect to the VM console via VNC and change its hostname and force its DHCP IP to change via these instructions: 

 - finding console port:
```
virsh dumpxml ubuntu-linux-srv6
```
find this line in output:
```
<graphics type='vnc' port='5903' autoport='yes' listen='0.0.0.0'>
```
 - in this example we VNC to host_ip:5903
 - vi /etc/hostname and /etc/hosts
 - edit /etc/netplan/00-installer-config.yaml to look like this:

```
network:
  ethernets:
    ens8:
      dhcp4: true
      dhcp-identifier: mac

    ens7: 
      addresses: 
        - 10.10.66.3/24
        - fc00:0:66:1::3/64
      routes:
        - to: 10.0.0.0/24
          via: 10.10.66.2
        - to: 10.10.46.0/24
          via: 10.10.66.2
        - to: fc00:0::/32
          via: fc00:0:66:1::2

  version: 2
```
 - apply netplan
```
sudo netplan apply
```
 - ifconfig should show ens8 with an IP different from ubuntu-vpp

5. ssh to the new VM using your normal credentials
6. remove /etc/vpp/startup.conf.orig as its no longer in use, and edit /etc/vpp/startup.conf, remove this line:
```
  dev 0000:00:07.0
```

7. reboot the VM, it should come up with ens7 as a normal linux interface:
```
brmcdoug@ubuntu-linux-srv6:~$ ifconfig ens7
ens7: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.66.2  netmask 255.255.255.0  broadcast 10.10.66.255
        inet6 fe80::5054:2ff:fe41:b107  prefixlen 64  scopeid 0x20<link>
        inet6 fd00:c0:a8:7a:1::aa  prefixlen 128  scopeid 0x0<global>
        ether 52:54:02:41:b1:07  txqueuelen 1000  (Ethernet)
        RX packets 318  bytes 24376 (24.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 34  bytes 2865 (2.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
8. on the host check which vnet the new VM is using for port ens7: 
```
virsh dumpxml ubuntu-linux-srv6
```
Example output, note slot='0x07' denotes ens7
```
    <interface type='network'>
      <mac address='52:54:02:41:b1:07'/>
      <source network='default' portid='0e3d5d24-47c1-4dd6-b427-04cf17bd9984' bridge='virbr0'/>
      <target dev='vnet13'/>          <------- this vnet
      <model type='virtio'/>
      <alias name='net0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </interface>
```
9. edit the last entry in util/nets.sh to match the vnet number above
```
docker network ls | awk -F': ' '/xrd_xrd66-host /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd66-host
echo br-"$netinstance"
sudo brctl delif virbr0 vnet13
sudo brctl addif br-"$netinstance" vnet13
```
10. run nets.sh
11. from the VM ping xrd66
```
brmcdoug@ubuntu-linux-srv6:~$ ping 10.10.66.2
PING 10.10.66.2 (10.10.66.2) 56(84) bytes of data.
64 bytes from 10.10.66.2: icmp_seq=1 ttl=255 time=3.55 ms
64 bytes from 10.10.66.2: icmp_seq=2 ttl=255 time=1.60 ms
```

12. add an SRv6 route!

```
sudo ip route add 10.11.46.0/24 encap seg6 mode encap segs fc00:0:18:3:46:e002:: dev ens7
```
 - the route above matches this SID entry on egress node xrd46, and thus xrd46 will perform SRv6 decapsulation:
```
*** Locator: 'MAIN' *** 
<snip>
fc00:0:46:e002::            uDT4              'default'                         bgp-65046           InUse  Y 
```

Alternative linux SRv6 route/encap:
```
sudo ip route add 10.11.46.0/24 encap seg6 mode encap segs fc00:0:18:3:46::,fc00:0:46:1::4 dev ens7
```
 - this route with multiple SIDs will result in the remote VPP performing SRv6 decapsulation
 - verbose (-vvv) tcpdump in the middle of the path gives a hint of the SRH in play:

```
09:02:41.747244 IP6 (hlim 58, next-header Routing (43) payload length: 124) fc00:0:66:1:5054:2ff:fe41:b107 > fc00:0:3:46::: srcrt (len=4, type=4, segleft=1[|srcrt]
```
