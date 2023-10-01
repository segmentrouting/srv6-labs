#!/bin/bash

# sudo clab tools vxlan delete

sudo clab tools vxlan create --remote 172.10.10.203 --id 10 --link leaf-1-eth1 --mtu 9200
sudo clab tools vxlan create --remote 172.10.10.203 --id 20 --link leaf-1-eth2 --mtu 9200
sudo clab tools vxlan create --remote 172.10.10.204 --id 30 --link leaf-1-eth3
sudo clab tools vxlan create --remote 172.10.10.204 --id 40 --link leaf-1-eth4