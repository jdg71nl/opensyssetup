#!/bin/bash

COMMUNITY=$1
IP=$2
if [[ -z "$IP" ]]; then
	echo "Usage: $0 <community> <ip>"
	exit 1;
fi
#    1.3.6.1.2.1.1.1 - sysDescr
#    1.3.6.1.2.1.1.2 - sysObjectID
#    1.3.6.1.2.1.1.3 - sysUpTime
#    1.3.6.1.2.1.1.4 - sysContact
#    1.3.6.1.2.1.1.5 - sysName
#    1.3.6.1.2.1.1.6 - sysLocation
#    1.3.6.1.2.1.1.7 - sysServices 
CMD="snmpwalk -v1 -c $COMMUNITY $IP system"
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.1" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.2" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.3" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.4" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.5" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.6" ; echo "# cmd: $CMD" ; $CMD
CMD="snmpwalk -v1 -c $COMMUNITY $IP 1.3.6.1.2.1.1.7" ; echo "# cmd: $CMD" ; $CMD

