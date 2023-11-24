#/bin/sh

docker-compose down

docker volume rm xrd01
docker volume rm xrd02
docker volume rm xrd03
docker volume rm xrd04
docker volume rm xrd05
docker volume rm xrd06
docker volume rm xrd07
docker volume rm xrd08
docker volume rm xrd09
docker volume rm xrd10
docker volume rm xrd11

sudo ifconfig xrd01-host down
sudo brctl delbr xrd01-host
sudo ifconfig xrd02-host down
sudo brctl delbr xrd02-host
sudo ifconfig xrd03-host down
sudo brctl delbr xrd03-host
sudo ifconfig xrd04-host down
sudo brctl delbr xrd04-host
sudo ifconfig xrd05-host down
sudo brctl delbr xrd05-host
sudo ifconfig xrd06-host down
sudo brctl delbr xrd06-host
sudo ifconfig xrd07-host down
sudo brctl delbr xrd07-host
sudo ifconfig xrd08-host down
sudo brctl delbr xrd08-host
sudo ifconfig xrd09-host down
sudo brctl delbr xrd09-host
sudo ifconfig xrd10-host down
sudo brctl delbr xrd10-host