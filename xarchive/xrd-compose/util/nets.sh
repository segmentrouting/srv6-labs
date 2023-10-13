#/bin/bash

echo "list docker networks"
docker network ls

echo "mapping docker networks to bridge instance files"

docker network ls | awk -F': ' '/xrd00-gi0-xrd02-gi6 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd00-xrd02
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd00-gi1-xrd03-gi6 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd00-xrd03
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd01-gi0-xrd02-gi5 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd01-xrd02
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd01-gi1-xrd03-gi5 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd01-xrd03
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd02-gi0-xrd03-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd02-xrd03
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd02-gi1-xrd11-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd02-xrd11
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd02-gi2-xrd04-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd02-xrd04
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd02-gi3-xrd19-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd02-xrd19
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd02-gi4-xrd23-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd02-xrd23
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd03-gi1-xrd05-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd03-xrd05
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd03-gi2-xrd12-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd03-xrd12
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd03-gi3-xrd18-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd03-xrd18
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd03-gi4-xrd22-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd03-xrd22
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd04-gi0-xrd05-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd04-xrd05
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd04-gi1-xrd08-gi4 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd04-xrd08
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd04-gi3-xrd06-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd04-xrd06
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd05-gi1-xrd07-gi2  /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd05-xrd07
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd05-gi3-xrd06-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd05-xrd06
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd05-gi4-xrd26-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd05-xrd26
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd07-gi0-xrd08-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd07-xrd08
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd07-gi1-xrd12-gi1  /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd07-xrd12
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd07-gi3-xrd10-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd07-xrd10
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd07-gi4-xrd09-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd07-xrd09
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd07-gi5-xrd25-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd07-xrd25
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd08-gi1-xrd09-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd08-xrd09
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd08-gi2-xrd10-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd08-xrd10
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd08-gi3-xrd11-gi4 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd08-xrd11
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd11-gi0-xrd12-gi0  /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd11-xrd12
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd11-gi1-xrd16-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd11-xrd16
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd11-gi2-xrd19-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd11-xrd19
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd11-gi5-xrd13-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd11-xrd13
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd11-gi6-xrd14-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd11-xrd14
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd12-gi3-xrd18-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd12-xrd18
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd12-gi4-xrd15-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd12-xrd15
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd12-gi5-xrd13-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd12-xrd13
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd12-gi6-xrd14-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd12-xrd14
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd15-gi0-xrd16-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd15-xrd16
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd15-gi1-xrd18-gi4 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd15-xrd18
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd15-gi3-xrd17-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd15-xrd17
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd16-gi2-xrd19-gi6 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd16-xrd19
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd16-gi3-xrd17-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd16-xrd17
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd18-gi0-xrd19-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd18-xrd19
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd18-gi1-xrd22-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd18-xrd22
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd18-gi5-xrd21-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd18-xrd21
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd18-gi6-xrd20-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd18-xrd20
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd19-gi3-xrd23-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd19-xrd23
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd19-gi4-xrd21-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd19-xrd21
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd19-gi5-xrd20-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd19-xrd20
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd22-gi0-xrd23-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd22-xrd23
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd22-gi3-xrd24-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd22-xrd24
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd23-gi2-xrd24-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd23-xrd24
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd40-gi0-xrd00-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd00
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd40-gi1-xrd01-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd01
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd40-gi2-xrd42-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd42
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd40-gi3-xrd43-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd43
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd40-gi4-xrd44-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd44
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd40-gi5-xrd45-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd40-xrd45
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd41-gi0-xrd00-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd00
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd41-gi1-xrd01-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd01
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd41-gi2-xrd42-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd42
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd41-gi3-xrd43-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd43
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd41-gi4-xrd44-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd44
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd41-gi5-xrd45-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd41-xrd45
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd42-gi2-xrd46-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd42-xrd46
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd42-gi3-xrd47-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd42-xrd47
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd43-gi2-xrd46-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd43-xrd46
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd43-gi3-xrd47-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd43-xrd47
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd44-gi2-xrd46-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd44-xrd46
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd44-gi3-xrd47-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd44-xrd47
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd45-gi2-xrd46-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd45-xrd46
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd45-gi3-xrd47-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd45-xrd47
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd60-gi0-xrd13-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd13
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd60-gi1-xrd14-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd14
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd60-gi2-xrd62-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd62
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd60-gi3-xrd63-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd63
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd60-gi4-xrd64-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd64
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd60-gi5-xrd65-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd60-xrd65
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd61-gi0-xrd13-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd13
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd61-gi1-xrd14-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd14
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd61-gi2-xrd62-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd62
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd61-gi3-xrd63-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd63
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd61-gi4-xrd64-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd64
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd61-gi5-xrd65-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd61-xrd65
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd62-gi2-xrd66-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd62-xrd66
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd62-gi3-xrd67-gi0 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd62-xrd67
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd63-gi2-xrd66-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd63-xrd66
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd63-gi3-xrd67-gi1 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd63-xrd67
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd64-gi2-xrd66-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd64-xrd66
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd64-gi3-xrd67-gi2 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd64-xrd67
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd65-gi2-xrd66-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd65-xrd66
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd65-gi3-xrd67-gi3 /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd65-xrd67
echo br-"$netinstance"


docker network ls | awk -F': ' '/xrd_xrd17-host /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd17-host
echo br-"$netinstance"

docker network ls | awk -F': ' '/xrd_xrd46-host /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd46-host
echo br-"$netinstance"
sudo brctl delif virbr0 vnet0
sudo brctl addif br-"$netinstance" vnet0

docker network ls | awk -F': ' '/xrd_xrd66-host /{print $0}' > net.txt
netinstance=$( head -n 1 net.txt | cut -c 1-12 )
echo br-"$netinstance" > ./xrd66-host
echo br-"$netinstance"
sudo brctl delif virbr0 vnet2
sudo brctl addif br-"$netinstance" vnet2

rm net.txt
