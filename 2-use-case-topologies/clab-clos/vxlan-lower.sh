#!/bin/sh

sudo clab tools vxlan delete -p clab

clab tools vxlan create --remote 198.18.1.105 --id 100 --link br01t02n00-Gi0-0-0-0
clab tools vxlan create --remote 198.18.1.105 --id 101 --link br02t02n00-Gi0-0-0-0

clab tools vxlan create --remote 198.18.1.105 --id 102 --link br01t02n00-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.105 --id 103 --link br02t02n00-Gi0-0-0-1

clab tools vxlan create --remote 198.18.1.105 --id 104 --link br01t02n00-Gi0-0-0-2
clab tools vxlan create --remote 198.18.1.105 --id 105 --link br02t02n00-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.105 --id 106 --link br01t02n00-Gi0-0-0-3
clab tools vxlan create --remote 198.18.1.105 --id 107 --link br02t02n00-Gi0-0-0-3


clab tools vxlan create --remote 198.18.1.105 --id 108 --link br01t02n01-Gi0-0-0-0
clab tools vxlan create --remote 198.18.1.105 --id 109 --link br02t02n01-Gi0-0-0-0

clab tools vxlan create --remote 198.18.1.105 --id 110 --link br01t02n01-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.105 --id 111 --link br02t02n01-Gi0-0-0-1

clab tools vxlan create --remote 198.18.1.105 --id 112 --link br01t02n01-Gi0-0-0-2
clab tools vxlan create --remote 198.18.1.105 --id 113 --link br02t02n01-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.105 --id 114 --link br01t02n01-Gi0-0-0-3
clab tools vxlan create --remote 198.18.1.105 --id 115 --link br02t02n01-Gi0-0-0-3


clab tools vxlan create --remote 198.18.1.105 --id 116 --link br01t02n02-Gi0-0-0-0
clab tools vxlan create --remote 198.18.1.105 --id 117 --link br02t02n02-Gi0-0-0-0

clab tools vxlan create --remote 198.18.1.105 --id 118 --link br01t02n02-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.105 --id 119 --link br02t02n02-Gi0-0-0-1

clab tools vxlan create --remote 198.18.1.105 --id 120 --link br01t02n02-Gi0-0-0-2
clab tools vxlan create --remote 198.18.1.105 --id 121 --link br02t02n02-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.105 --id 122 --link br01t02n02-Gi0-0-0-3
clab tools vxlan create --remote 198.18.1.105 --id 123 --link br02t02n02-Gi0-0-0-3


clab tools vxlan create --remote 198.18.1.105 --id 124 --link br01t02n03-Gi0-0-0-0
clab tools vxlan create --remote 198.18.1.105 --id 125 --link br02t02n03-Gi0-0-0-0

clab tools vxlan create --remote 198.18.1.105 --id 126 --link br01t02n03-Gi0-0-0-1
clab tools vxlan create --remote 198.18.1.105 --id 127 --link br02t02n03-Gi0-0-0-1

clab tools vxlan create --remote 198.18.1.105 --id 128 --link br01t02n03-Gi0-0-0-2
clab tools vxlan create --remote 198.18.1.105 --id 129 --link br02t02n03-Gi0-0-0-2

clab tools vxlan create --remote 198.18.1.105 --id 130 --link br01t02n03-Gi0-0-0-3
clab tools vxlan create --remote 198.18.1.105 --id 131 --link br02t02n03-Gi0-0-0-3