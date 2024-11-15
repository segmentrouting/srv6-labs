#!/bin/sh

sudo clab tools vxlan delete -p clab

# SS 01
sudo clab tools vxlan create --remote 198.18.1.100 --id 100 --link SS01-Gi0-0-0-8 
sudo clab tools vxlan create --remote 198.18.1.100 --id 101 --link SS01-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.100 --id 102 --link SS01-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.100 --id 103 --link SS01-Gi0-0-0-11

# SS 02
sudo clab tools vxlan create --remote 198.18.1.100 --id 104 --link SS02-Gi0-0-0-8 
sudo clab tools vxlan create --remote 198.18.1.100 --id 105 --link SS02-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.100 --id 106 --link SS02-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.100 --id 107 --link SS02-Gi0-0-0-11

# SS 03
sudo clab tools vxlan create --remote 198.18.1.100 --id 108 --link SS03-Gi0-0-0-8 
sudo clab tools vxlan create --remote 198.18.1.100 --id 109 --link SS03-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.100 --id 110 --link SS03-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.100 --id 111 --link SS03-Gi0-0-0-11

# SS 04
sudo clab tools vxlan create --remote 198.18.1.100 --id 112 --link SS04-Gi0-0-0-8 
sudo clab tools vxlan create --remote 198.18.1.100 --id 113 --link SS04-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.100 --id 114 --link SS04-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.100 --id 115 --link SS04-Gi0-0-0-11

