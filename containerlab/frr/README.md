### An 8-node SRv6 lab using FRR
Many thanks to Brian Linkletter as his blog post gave this lab a jumpstart: 
https://www.brianlinkletter.com/2021/05/use-containerlab-to-emulate-open-source-routers/

### Topology

          r2--r4
         /    |  \
   r7--r1     |   r6--r8
         \    |  /
          r3--r5

```
sudo containerlab deploy -t frr.yml
```