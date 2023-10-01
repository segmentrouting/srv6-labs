## Ansible playbooks

SONiC configuration is managed in two places:

1. /etc/sonic/config_db.json file - host/node global parameters, interface IPs, etc.
2. FRR - routing protocols

We've included several Ansible playbooks for setting up the 3 or 4 node topologies into different routing use cases:

1. eBGP fabric
   1. VXLAN EVPN
   2. SRv6 L3VPN
2. eBGP fabric with ip/bgp unnumbered peering
   1. VXLAN EVPN
   2. SRv6 L3VPN
3. ISIS 