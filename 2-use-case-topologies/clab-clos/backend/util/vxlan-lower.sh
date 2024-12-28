#!/bin/sh

sudo clab tools vxlan delete -p clab

# SP65 - SP68 up to SS01 - SS04
sudo clab tools vxlan create --remote 198.18.1.101 --id 100 --link SP65-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.101 --id 101 --link SP66-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.101 --id 102 --link SP67-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.101 --id 103 --link SP68-Gi0-0-0-0

sudo clab tools vxlan create --remote 198.18.1.101 --id 104 --link SP65-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.101 --id 105 --link SP66-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.101 --id 106 --link SP67-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.101 --id 107 --link SP68-Gi0-0-0-1

sudo clab tools vxlan create --remote 198.18.1.101 --id 108 --link SP65-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.101 --id 109 --link SP66-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.101 --id 110 --link SP67-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.101 --id 111 --link SP68-Gi0-0-0-2

sudo clab tools vxlan create --remote 198.18.1.101 --id 112 --link SP65-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.101 --id 113 --link SP66-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.101 --id 114 --link SP67-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.101 --id 115 --link SP68-Gi0-0-0-3

