#!/bin/bash

sudo clab tools vxlan create --remote 172.10.10.202 --id 10 --link spine-2-eth1
sudo clab tools vxlan create --remote 172.10.10.202 --id 20 --link spine-2-eth2
sudo clab tools vxlan create --remote 172.10.10.201 --id 30 --link spine-2-eth3
sudo clab tools vxlan create --remote 172.10.10.201 --id 40 --link spine-2-eth4