#!/bin/sh

sudo clab tools vxlan delete -p clab

# up to SS01
sudo clab tools vxlan create --remote 198.18.1.105 --id 100 --link SP01-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 101 --link SP02-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 102 --link SP03-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 103 --link SP04-Gi0-0-0-0

sudo clab tools vxlan create --remote 198.18.1.105 --id 104 --link SP05-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 105 --link SP06-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 106 --link SP07-Gi0-0-0-0
sudo clab tools vxlan create --remote 198.18.1.105 --id 107 --link SP08-Gi0-0-0-0

# up to SS02
sudo clab tools vxlan create --remote 198.18.1.105 --id 108 --link SP01-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 109 --link SP02-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 110 --link SP03-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 111 --link SP04-Gi0-0-0-1

sudo clab tools vxlan create --remote 198.18.1.105 --id 112 --link SP05-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 113 --link SP06-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 114 --link SP07-Gi0-0-0-1
sudo clab tools vxlan create --remote 198.18.1.105 --id 115 --link SP08-Gi0-0-0-1


# up to SS03
sudo clab tools vxlan create --remote 198.18.1.105 --id 116 --link SP01-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 117 --link SP02-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 118 --link SP03-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 119 --link SP04-Gi0-0-0-2

sudo clab tools vxlan create --remote 198.18.1.105 --id 120 --link SP05-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 121 --link SP06-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 122 --link SP07-Gi0-0-0-2
sudo clab tools vxlan create --remote 198.18.1.105 --id 123 --link SP08-Gi0-0-0-2

# up to SS04
sudo clab tools vxlan create --remote 198.18.1.105 --id 124 --link SP01-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 125 --link SP02-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 126 --link SP03-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 127 --link SP04-Gi0-0-0-3

sudo clab tools vxlan create --remote 198.18.1.105 --id 128 --link SP05-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 129 --link SP06-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 130 --link SP07-Gi0-0-0-3
sudo clab tools vxlan create --remote 198.18.1.105 --id 131 --link SP08-Gi0-0-0-3


# up to SS05
sudo clab tools vxlan create --remote 198.18.1.105 --id 132 --link SP01-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 133 --link SP02-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 134 --link SP03-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 135 --link SP04-Gi0-0-0-4

sudo clab tools vxlan create --remote 198.18.1.105 --id 136 --link SP05-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 137 --link SP06-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 138 --link SP07-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 139 --link SP08-Gi0-0-0-4

# up to SS06
sudo clab tools vxlan create --remote 198.18.1.105 --id 140 --link SP01-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 141 --link SP02-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 142 --link SP03-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 143 --link SP04-Gi0-0-0-5

sudo clab tools vxlan create --remote 198.18.1.105 --id 144 --link SP05-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 145 --link SP06-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 146 --link SP07-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 147 --link SP08-Gi0-0-0-5


# up to SS07
sudo clab tools vxlan create --remote 198.18.1.105 --id 148 --link SP01-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 149 --link SP02-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 150 --link SP03-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 151 --link SP04-Gi0-0-0-6

sudo clab tools vxlan create --remote 198.18.1.105 --id 152 --link SP05-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 153 --link SP06-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 154 --link SP07-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 155 --link SP08-Gi0-0-0-6

# up to SS08
sudo clab tools vxlan create --remote 198.18.1.105 --id 156 --link SP01-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 157 --link SP02-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 158 --link SP03-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 159 --link SP04-Gi0-0-0-7

sudo clab tools vxlan create --remote 198.18.1.105 --id 160 --link SP05-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 161 --link SP06-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 162 --link SP07-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 163 --link SP08-Gi0-0-0-7
