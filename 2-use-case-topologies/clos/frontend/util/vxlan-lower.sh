#!/bin/sh

sudo clab tools vxlan delete -p clab

# up to SS00
sudo clab tools vxlan create --remote 198.18.1.105 --id 100 --link SP16-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 101 --link SP17-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 102 --link SP18-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 103 --link SP19-Gi0-0-0-4

sudo clab tools vxlan create --remote 198.18.1.105 --id 104 --link SP32-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 105 --link SP33-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 106 --link SP34-Gi0-0-0-4
sudo clab tools vxlan create --remote 198.18.1.105 --id 107 --link SP35-Gi0-0-0-4

# up to SS01
sudo clab tools vxlan create --remote 198.18.1.105 --id 108 --link SP16-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 109 --link SP17-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 110 --link SP18-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 111 --link SP19-Gi0-0-0-5

sudo clab tools vxlan create --remote 198.18.1.105 --id 112 --link SP32-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 113 --link SP33-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 114 --link SP34-Gi0-0-0-5
sudo clab tools vxlan create --remote 198.18.1.105 --id 115 --link SP35-Gi0-0-0-5


# up to SS02
sudo clab tools vxlan create --remote 198.18.1.105 --id 116 --link SP16-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 117 --link SP17-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 118 --link SP18-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 119 --link SP19-Gi0-0-0-6

sudo clab tools vxlan create --remote 198.18.1.105 --id 120 --link SP32-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 121 --link SP33-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 122 --link SP34-Gi0-0-0-6
sudo clab tools vxlan create --remote 198.18.1.105 --id 123 --link SP35-Gi0-0-0-6

# up to SS03
sudo clab tools vxlan create --remote 198.18.1.105 --id 124 --link SP16-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 125 --link SP17-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 126 --link SP18-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 127 --link SP19-Gi0-0-0-7

sudo clab tools vxlan create --remote 198.18.1.105 --id 128 --link SP32-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 129 --link SP33-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 130 --link SP34-Gi0-0-0-7
sudo clab tools vxlan create --remote 198.18.1.105 --id 131 --link SP35-Gi0-0-0-7


# up to SS04
sudo clab tools vxlan create --remote 198.18.1.105 --id 132 --link SP16-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 133 --link SP17-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 134 --link SP18-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 135 --link SP19-Gi0-0-0-8

sudo clab tools vxlan create --remote 198.18.1.105 --id 136 --link SP32-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 137 --link SP33-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 138 --link SP34-Gi0-0-0-8
sudo clab tools vxlan create --remote 198.18.1.105 --id 139 --link SP35-Gi0-0-0-8

# up to SS05
sudo clab tools vxlan create --remote 198.18.1.105 --id 140 --link SP16-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 141 --link SP17-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 142 --link SP18-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 143 --link SP19-Gi0-0-0-9

sudo clab tools vxlan create --remote 198.18.1.105 --id 144 --link SP32-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 145 --link SP33-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 146 --link SP34-Gi0-0-0-9
sudo clab tools vxlan create --remote 198.18.1.105 --id 147 --link SP35-Gi0-0-0-9


# up to SS06
sudo clab tools vxlan create --remote 198.18.1.105 --id 148 --link SP16-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 149 --link SP17-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 116 --link SP18-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 117 --link SP19-Gi0-0-0-10

sudo clab tools vxlan create --remote 198.18.1.105 --id 118 --link SP32-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 119 --link SP33-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 154 --link SP34-Gi0-0-0-10
sudo clab tools vxlan create --remote 198.18.1.105 --id 155 --link SP35-Gi0-0-0-10

# up to SS07
sudo clab tools vxlan create --remote 198.18.1.105 --id 156 --link SP16-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 157 --link SP17-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 158 --link SP18-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 159 --link SP19-Gi0-0-0-11

sudo clab tools vxlan create --remote 198.18.1.105 --id 160 --link SP32-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 161 --link SP33-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 162 --link SP34-Gi0-0-0-11
sudo clab tools vxlan create --remote 198.18.1.105 --id 163 --link SP35-Gi0-0-0-11
