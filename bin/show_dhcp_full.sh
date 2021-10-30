#!/bin/bash

/usr/local/syssetup/bin/show_dhcp.sh

for x in 3 4 5 6 7 8 9 10 11 12 13 14; do
	echo "# --- "
        FILE="10.$x.20.250"
        if [ -r $FILE ] ; then
                echo -n "# --- Nr DHCP-leases op locatie $x (IP: $FILE): "
                cat $FILE | egrep 'DHCP.*Automatic' | wc -l
                cat $FILE | egrep 'DHCP.*Automatic'
        else
                echo "# no file '$FILE'"
        fi
done

exit

echo "# --- "
echo "# LLDP neighbours (serial nr APs):"

for x in 3 4 5 6 7 8 9 10 11 12 13 14; do
	echo "# --- "
        FILE="10.$x.20.250"
        if [ -r $FILE ] ; then
                echo -n "# --- Nr DHCP-leases op locatie $x (IP: $FILE): "
                cat $FILE | egrep '^!LLDP.*'
        else
                echo "# no file '$FILE'"
        fi
done

