#!/bin/bash

#sudo clab tools vxlan delete

sudo clab tools vxlan create --remote 172.10.10.201 --id 10 --link spine-1-eth1 --mtu 9200
sudo clab tools vxlan create --remote 172.10.10.201 --id 20 --link spine-1-eth2 --mtu 9200
sudo clab tools vxlan create --remote 172.10.10.202 --id 30 --link spine-1-eth3
sudo clab tools vxlan create --remote 172.10.10.202 --id 40 --link spine-1-eth4