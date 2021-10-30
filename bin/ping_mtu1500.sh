#!/bin/bash
IP=$1
echo "# will ping with ICMP body size=1472, ICMP msg=1480, IP-size=1500"
CMD="ping -Mdo -c3 -i0.5 -s1472 $IP"
echo $CMD
$CMD

