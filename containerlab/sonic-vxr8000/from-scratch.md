### install and launch 8000e SONiC from scratch

1. Download tarballs to a common directory: http://vxr8000.cisco.com/8000/eft7.8/sonic/
```
cisco@ubuntu:~/images/8000-eft7.8$ ls ~/images/
8000-emulator-eft7.8.tar  8000-sonic-eft7.8.tar
```

2. cd into the directory and untar using this command:
```
find . -name '*.tar' -exec tar -xvf {} \;
```

3. cd into the newly created 8000-eft.x.y directory and run the docker build image shell script:
```
cd 8000-eft7.8/
./scripts/build_docker_image.sh 8000:7.8 ./docker/sonic/Dockerfile 
```

4. the build script takes a few minutes. successful build will end with something like:
```
=> exporting to image                                                                                           28.0s
=> => exporting layers                                                                                          28.0s
=> => writing image sha256:8c0650ec1724fe8d55ce4d9b4fc0cb075dd8b0b0361ac2196ecc42e62b5aa272                      0.0s
=> => naming to docker.io/library/8000:7.8                                                                       0.0s
```

5. Verify docker image with 'docker image ls':
```
cisco@ubuntu:~/images/8000-eft7.8$ docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
8000         7.8       8c0650ec1724   10 minutes ago   11.3GB
```

6. Install containerlab

7. Launch topology:
```
sudo containerlab deploy -t 3-node.yml 
```
 - successful launch output:
```
INFO[0000] Containerlab v0.38.0 started                 
INFO[0000] Parsing & checking topology file: 3-node.yml 
INFO[0000] Creating lab directory: /home/cisco/vxr8000/sonic/clab-c8201-3-node-SONiC-net 
INFO[0001] Creating docker network: Name="clab", IPv4Subnet="172.20.20.0/24", IPv6Subnet="2001:172:20:20::/64", MTU="1500" 
INFO[0001] Creating container: "r1"                     
INFO[0001] Creating container: "r3"                     
INFO[0001] Creating container: "r2"                     
INFO[0003] Creating virtual wire: r2:eth2 <--> r3:eth2  
INFO[0004] Creating virtual wire: r1:eth2 <--> r3:eth1  
INFO[0004] Creating virtual wire: r1:eth1 <--> r2:eth1  
INFO[0005] Adding containerlab host entries to /etc/hosts file 
+---+--------------------------------+--------------+----------+-------+---------+----------------+----------------------+
| # |              Name              | Container ID |  Image   | Kind  |  State  |  IPv4 Address  |     IPv6 Address     |
+---+--------------------------------+--------------+----------+-------+---------+----------------+----------------------+
| 1 | clab-c8201-3-node-SONiC-net-r1 | 40650df45a42 | 8000:7.8 | linux | running | 172.20.20.2/24 | 2001:172:20:20::2/64 |
| 2 | clab-c8201-3-node-SONiC-net-r2 | 9b90fa4119af | 8000:7.8 | linux | running | 172.20.20.3/24 | 2001:172:20:20::3/64 |
| 3 | clab-c8201-3-node-SONiC-net-r3 | 1aaa09089db2 | 8000:7.8 | linux | running | 172.20.20.4/24 | 2001:172:20:20::4/64 |
+---+--------------------------------+--------------+----------+-------+---------+----------------+----------------------+
```

8. Watch docker container logs:
```
docker logs -f clab-c8201-3-node-SONiC-net-r1
```