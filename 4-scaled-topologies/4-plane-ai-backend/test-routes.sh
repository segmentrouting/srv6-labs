#!/bin/bash

docker exec -it green-host00 ip -6 route add 2001:db8:bbbb:f::2/64 encap seg6 mode encap.red segs fc00:0:f000:e00f:d000:: dev eth1
docker exec -it green-host00 ip -6 route add 2001:db8:bbbb:10f::2/64 encap seg6 mode encap.red segs fc00:1:f000:e00f:d000:: dev eth2
docker exec -it green-host00 ip -6 route add 2001:db8:bbbb:20f::2/64 encap seg6 mode encap.red segs fc00:2:f000:e00f:d000:: dev eth3
docker exec -it green-host00 ip -6 route add 2001:db8:bbbb:30f::2/64 encap seg6 mode encap.red segs fc00:3:f000:e00f:d000:: dev eth4

docker exec -it green-host15 ip -6 route add 2001:db8:bbbb::2/64 encap seg6 mode encap.red segs fc00:0:f000:e000:d000:: dev eth1
docker exec -it green-host15 ip -6 route add 2001:db8:bbbb:100::2/64 encap seg6 mode encap.red segs fc00:1:f000:e000:d000:: dev eth2
docker exec -it green-host15 ip -6 route add 2001:db8:bbbb:200::2/64 encap seg6 mode encap.red segs fc00:2:f000:e000:d000:: dev eth3
docker exec -it green-host15 ip -6 route add 2001:db8:bbbb:300::2/64 encap seg6 mode encap.red segs fc00:3:f000:e000:d000:: dev eth4

docker exec -it yellow-host00 ip -6 route add 2001:db8:cccc:f::2/64 encap seg6 mode encap.red segs fc00:0:f001:e00f:d000:: dev eth1
docker exec -it yellow-host00 ip -6 route add 2001:db8:cccc:10f::2/64 encap seg6 mode encap.red segs fc00:1:f001:e00f:d000:: dev eth2
docker exec -it yellow-host00 ip -6 route add 2001:db8:cccc:20f::2/64 encap seg6 mode encap.red segs fc00:2:f001:e00f:d000:: dev eth3
docker exec -it yellow-host00 ip -6 route add 2001:db8:cccc:30f::2/64 encap seg6 mode encap.red segs fc00:3:f001:e00f:d000:: dev eth4

docker exec -it yellow-host15 ip -6 route add 2001:db8:cccc::2/64 encap seg6 mode encap.red segs fc00:0:f000:e000:d000:: dev eth1
docker exec -it yellow-host15 ip -6 route add 2001:db8:cccc:100::2/64 encap seg6 mode encap.red segs fc00:1:f000:e000:d000:: dev eth2
docker exec -it yellow-host15 ip -6 route add 2001:db8:cccc:200::2/64 encap seg6 mode encap.red segs fc00:2:f000:e000:d000:: dev eth3
docker exec -it yellow-host15 ip -6 route add 2001:db8:cccc:300::2/64 encap seg6 mode encap.red segs fc00:3:f000:e000:d000:: dev eth4