## 4-node sonic vxr8000 topology

This topology uses linux bridge as for underlying router-to-router connectivity


1. Run the 'create-bridges.sh shell script prior to deploying the topology'

```
./create-bridges.sh
```

2. Deploy
```
sudo containerlab deploy -t clab-4-node-8000e.yml
```

Ansible folder is currently under construction