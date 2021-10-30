#!/bin/bash

COMMUNITY=$1
IP=$2
if [[ -z "$IP" ]]; then
	echo "Usage: $0 <community> <ip>"
	exit 1;
fi
# 1.3.6.1.2.1.2.2.1.2 - ifDescr
CMD="snmpwalk -v1 -c $COMMUNITY $IP IF-MIB::ifDescr"
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.2.2.1.2"
echo "# cmd: $CMD"
$CMD

