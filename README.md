# srv6-labs
A repository containing several types of SRv6 lab or demo projects.

The repository is organized around network topology scenarios and the tools used to launch a given topology. For example:

* [1-starter-topologies](./1-starter-topologies/) - contains topology definition yaml files and router configs for quickly getting up and running using the Containerlab or KNE topology orchestrators. 

* [2-use-case-topologies](./2-use-case-topologies/) - contains topology definition yaml files and router configs for running larger, more complex SRv6 scenarios using Containerlab, KNE, VXR, or xr-compose

* Note: some of the KNE examples are still a work in progress 

Each project subdirectory includes READMEs, scripts, configs, and other tools for building SRv6 topologies and running various simulation or demo scenarios.

For more info on Containerlab and KNE: 

https://containerlab.dev/

https://github.com/openconfig/kne

### utils directory
Utility scripts and other tools that might be useful on any of the SRv6 Labs in this repository. The host-check script among other things provides an estimate on the number of XRd instances you can run based on your host/VM's CPU and memory counts.

### xarchive directory
Semi-archived instructions, scripts, sample ymls, and configs for using Cisco's 'xr-compose' tool to build and launch xrd network topologies. xr-compose leverages docker-compose under the hood

### VPP subdirectory
I threw this one in for anyone who might want to attach an SRv6-enabled VPP instance to one of the above

#### Contributions are welcome!
