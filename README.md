# srv6-labs
A repository containing several types of SRv6 lab or demo projects.

The repository is organized around network topology scenarios and the tools used to launch a given topology. For example:

* [1-starter-topologies](./1-starter-topologies/) - contains topology definition yaml files and router configs for quickly getting up and running using the Containerlab or KNE topology orchestrators. 

* [2-large-topologies](./2-large-topologies/) - contains topology definition yaml files and router configs for running larger, more complex SRv6 scenarios using Containerlab or KNE

Each project subdirectory includes READMEs, scripts, configs, and other tools for building SRv6 topologies and running various simulation or demo scenarios.

For more info on Containerlab and KNE: 
https://containerlab.dev/
https://github.com/openconfig/kne

### utils directory
Utility scripts and other tools that might be useful on any of the SRv6 Labs in this repository

### xarchive directory
Semi-archived instructions, scripts, sample ymls, and configs for using Cisco's 'xr-compose' tool to build and launch xrd network topologies. xr-compose leverages docker-compose under the hood

### VPP subdirectory
I threw this one in for anyone who might want to attach an SRv6-enabled VPP instance to one of the above

#### Contributions are welcome!
