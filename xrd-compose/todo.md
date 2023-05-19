### XRd changes for Feb 20 merge:

#### XRd00 and XRd01 
 - redistribute Paris DC SRv6 SID range into ISIS
```
route-policy dc-aggregate
  if destination in (fc00:0:40::/45 ge 45 le 128) then
    pass
  else
    drop
  endif
end-policy
!
router isis 100
 !
 address-family ipv6 unicast
  redistribute bgp 65000 route-policy dc-aggregate
```
#### XRd46
 - change VPP-facing interface IPv6 addr to be part of DC SRv6 SID range
 - create a VPP host static route and redist into BGP
```
interface GigabitEthernet0/0/0/4
 no ipv6 address 2001:1:10:46::2/64
 ipv6 address fc00:0:46:1::2/64
!
route-policy xrd46-host
  if destination in (10.11.46.0/24) then
    pass
  else
    drop
  endif
end-policy
!
router static
 address-family ipv4 unicast
  10.11.46.0/24 10.10.46.3
 !
!
router bgp 65046
 address-family ipv4 unicast
  redistribute static route-policy xrd46-host
 !
 address-family ipv6 unicast
  network fc00:0:46:1::/64
 !
!
end
```

### cilium VM


1. setup SRv6 policies for alpine

### VPP VM

1. should we use calico-vpp or just plain vpp?
2. stretch goal: govpp api