## trex setup

### exec into container
```
docker exec -it clab-peterson-trex01 bash
```

### config container and start trex daemon in stateless mode
```
ip addr add 10.101.1.2/24 dev eth1
ip route del default via 172.20.15.1 dev eth0
ip route add default via 10.101.1.1 dev eth1
./t-rex-64 -i                               
```

### access trex console in separate container bash session
```
docker exec -it clab-peterson-trex01 bash
./trex-console 
```

### run a traffic test
```
start -f srv6-labs/trex01-imix.py -m 10kpps --port 0
```

### check traffic with tui
```
tui
```