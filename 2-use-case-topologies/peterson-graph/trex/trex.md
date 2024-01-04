## trex setup

1. exec into container
```
docker exec -it clab-ubtrex-ubtrex01 bash
```
2. replace container /etc/trex_cfg.yaml

3. config container IP and start trex daemon in stateless mode
```
ip addr add 10.101.1.2/24 dev eth1
ip addr add fc00:0:101:1::2/64 dev eth1
ip route del default via 172.20.15.1 dev eth0
ip route add default via 10.101.1.1 dev eth1
ip -6 route add fc00:0000::/32 via fc00:0:101:1::1
./t-rex-64 -i                               
```

4. access trex console in separate container bash session
```
docker exec -it clab-peterson-trex01 bash
./trex-console 
```

5. run a traffic test
```
start -f srv6/imix.py -m 1kpps --port 0
start -f srv6/srv6.py --port 0
```

6. check traffic with tui
```
tui
```