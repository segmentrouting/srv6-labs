Built using:
https://docs.frrouting.org/projects/dev-guide/en/latest/building-frr-for-ubuntu2204.html

user: admin
pw: admin123

installed packages:

iproute2
openssh-server

docker exec -it clab-frr-frr-1 bash
systemctl start frr
exit

docker exec -it clab-frr-frr-2 bash
systemctl start frr
exit


