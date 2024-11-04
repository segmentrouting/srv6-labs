#!/bin/sh

sudo clab tools vxlan delete -p clab

# SS 01
clab tools vxlan create --remote 198.18.1.100 --id 100 --link SS01-Gi0-0-0-8 
clab tools vxlan create --remote 198.18.1.100 --id 101 --link SS01-Gi0-0-0-9
clab tools vxlan create --remote 198.18.1.100 --id 102 --link SS01-Gi0-0-0-10
clab tools vxlan create --remote 198.18.1.100 --id 103 --link SS01-Gi0-0-0-11
# clab tools vxlan create --remote 198.18.1.100 --id 100 --link SS01-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 101 --link SS01-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 102 --link SS01-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 103 --link SS01-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 104 --link SS01-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 105 --link SS01-Gi0-0-0-5 
# clab tools vxlan create --remote 198.18.1.100 --id 106 --link SS01-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 107 --link SS01-Gi0-0-0-7

# SS 02
clab tools vxlan create --remote 198.18.1.100 --id 104 --link SS02-Gi0-0-0-8 
clab tools vxlan create --remote 198.18.1.100 --id 105 --link SS02-Gi0-0-0-9
clab tools vxlan create --remote 198.18.1.100 --id 106 --link SS02-Gi0-0-0-10
clab tools vxlan create --remote 198.18.1.100 --id 107 --link SS02-Gi0-0-0-11
# clab tools vxlan create --remote 198.18.1.100 --id 108 --link SS02-Gi0-0-0-0     
# clab tools vxlan create --remote 198.18.1.100 --id 109 --link SS02-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 110 --link SS02-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 111 --link SS02-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 112 --link SS02-Gi0-0-0-4
# clab tools vxlan create --remote 198.18.1.100 --id 113 --link SS02-Gi0-0-0-5 
# clab tools vxlan create --remote 198.18.1.100 --id 114 --link SS02-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 115 --link SS02-Gi0-0-0-7

# SS 03
clab tools vxlan create --remote 198.18.1.100 --id 108 --link SS03-Gi0-0-0-8 
clab tools vxlan create --remote 198.18.1.100 --id 109 --link SS03-Gi0-0-0-9
clab tools vxlan create --remote 198.18.1.100 --id 110 --link SS03-Gi0-0-0-10
clab tools vxlan create --remote 198.18.1.100 --id 111 --link SS03-Gi0-0-0-11
# clab tools vxlan create --remote 198.18.1.100 --id 116 --link SS03-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 117 --link SS03-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 118 --link SS03-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 119 --link SS03-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 120 --link SS03-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 121 --link SS03-Gi0-0-0-5 
# clab tools vxlan create --remote 198.18.1.100 --id 122 --link SS03-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 123 --link SS03-Gi0-0-0-7

# SS 04
clab tools vxlan create --remote 198.18.1.100 --id 112 --link SS04-Gi0-0-0-8 
clab tools vxlan create --remote 198.18.1.100 --id 113 --link SS04-Gi0-0-0-9
clab tools vxlan create --remote 198.18.1.100 --id 114 --link SS04-Gi0-0-0-10
clab tools vxlan create --remote 198.18.1.100 --id 115 --link SS04-Gi0-0-0-11
# clab tools vxlan create --remote 198.18.1.100 --id 124 --link SS04-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 125 --link SS04-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 126 --link SS04-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 127 --link SS04-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 128 --link SS04-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 129 --link SS04-Gi0-0-0-5
# clab tools vxlan create --remote 198.18.1.100 --id 130 --link SS04-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 131 --link SS04-Gi0-0-0-7

# SS 05

# clab tools vxlan create --remote 198.18.1.100 --id 132 --link SS05-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 133 --link SS05-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 134 --link SS05-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 135 --link SS05-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 136 --link SS05-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 137 --link SS05-Gi0-0-0-5
# clab tools vxlan create --remote 198.18.1.100 --id 138 --link SS05-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 139 --link SS05-Gi0-0-0-7

# SS 06
# clab tools vxlan create --remote 198.18.1.100 --id 140 --link SS06-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 141 --link SS06-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 142 --link SS06-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 143 --link SS06-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 144 --link SS06-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 145 --link SS06-Gi0-0-0-5
# clab tools vxlan create --remote 198.18.1.100 --id 146 --link SS06-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 147 --link SS06-Gi0-0-0-7

# SS 07
# clab tools vxlan create --remote 198.18.1.100 --id 148 --link SS07-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 149 --link SS07-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 150 --link SS07-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 151 --link SS07-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 152 --link SS07-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 153 --link SS07-Gi0-0-0-5
# clab tools vxlan create --remote 198.18.1.100 --id 154 --link SS07-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 155 --link SS07-Gi0-0-0-7

# SS 08
# clab tools vxlan create --remote 198.18.1.100 --id 156 --link SS08-Gi0-0-0-0 
# clab tools vxlan create --remote 198.18.1.100 --id 157 --link SS08-Gi0-0-0-1
# clab tools vxlan create --remote 198.18.1.100 --id 158 --link SS08-Gi0-0-0-2
# clab tools vxlan create --remote 198.18.1.100 --id 159 --link SS08-Gi0-0-0-3
# clab tools vxlan create --remote 198.18.1.100 --id 160 --link SS08-Gi0-0-0-4 
# clab tools vxlan create --remote 198.18.1.100 --id 161 --link SS08-Gi0-0-0-5
# clab tools vxlan create --remote 198.18.1.100 --id 162 --link SS08-Gi0-0-0-6
# clab tools vxlan create --remote 198.18.1.100 --id 163 --link SS08-Gi0-0-0-7
