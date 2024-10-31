#!/bin/sh

sudo clab tools vxlan delete -p clab

clab tools vxlan create --remote 198.18.1.100 --id 100 --link sp00c00n00-Gi0-0-0-1 --mtu 1400
clab tools vxlan create --remote 198.18.1.100 --id 101 --link sp00c00n00-Gi0-0-0-2 --mtu 1400

clab tools vxlan create --remote 198.18.1.100 --id 102 --link sp00c01n00-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 103 --link sp00c01n00-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 104 --link sp00c02n00-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 105 --link sp00c02n00-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 106 --link sp00c03n00-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 107 --link sp00c03n00-Gi0-0-0-2


clab tools vxlan create --remote 198.18.1.100 --id 108 --link sp00c00n01-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 109 --link sp00c00n01-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 110 --link sp00c01n01-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 111 --link sp00c01n01-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 112 --link sp00c02n01-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 113 --link sp00c02n01-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 114 --link sp00c03n01-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 115 --link sp00c03n01-Gi0-0-0-2


clab tools vxlan create --remote 198.18.1.100 --id 116 --link sp00c00n02-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 117 --link sp00c00n02-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 118 --link sp00c01n02-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 119 --link sp00c01n02-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 120 --link sp00c02n02-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 121 --link sp00c02n02-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 122 --link sp00c03n02-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 123 --link sp00c03n02-Gi0-0-0-2


clab tools vxlan create --remote 198.18.1.100 --id 124 --link sp00c00n03-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 125 --link sp00c00n03-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 126 --link sp00c01n03-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 127 --link sp00c01n03-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 128 --link sp00c02n03-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 129 --link sp00c02n03-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.100 --id 130 --link sp00c03n03-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.100 --id 131 --link sp00c03n03-Gi0-0-0-2