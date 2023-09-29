# srv6-labs
A repository containing several types of SRv6 lab or demo projects.

The repository is organized around network topology scenarios and the tools used to launch a given topology. For example:

* clab-quickstart - contains topology definition yaml files and router configs for quickly getting up and running using the containerlab (clab) topology orchestrator. See also: https://containerlab.dev/
  
* kvm - prebuilt xml files and configs for launching virtual machine topologies using kvm

Each project subdirectory includes READMEs, scripts, configs, and other tools for building SRv6 topologies and running various simulation or demo scenarios.

### Containerlab subdirectory
Contains instructions, sample ymls, and configs for using Containerlab to build and launch sonic-vxr8000 or xrd network topologies
https://containerlab.dev/

Will develop a Containerlab sonic setup soon

### sonic-vs subdirectory
Contains instructions, sample xml, and configs for using virsh to build and launch sonic-vs network topologies
https://sonic.software/

### xrd-compose subdirectory
Contains instructions, scripts, sample ymls, and configs for using Cisco's 'xr-compose' tool to build and launch xrd network topologies. xr-compose leverages docker-compose under the hood

### VPP subdirectory
I threw this one in for anyone who might want to attach an SRv6-enabled VPP instance to one of the above


#### Contributions are welcome!
