#/bin/bash

line=$(head -n 1 $1)
echo "sudo tcpdump -ni $line"
sudo tcpdump -ni $line