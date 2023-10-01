#!/bin/bash

# sudo clab tools vxlan delete

sudo clab tools vxlan create --remote 172.10.10.204 --id 10 --link leaf-2-eth1
sudo clab tools vxlan create --remote 172.10.10.204 --id 20 --link leaf-2-eth2
sudo clab tools vxlan create --remote 172.10.10.203 --id 30 --link leaf-2-eth3
sudo clab tools vxlan create --remote 172.10.10.203 --id 40 --link leaf-2-eth4