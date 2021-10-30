#!/bin/bash

echo "# --- "
echo -n "# Nr DHCP-leases op ALLE locaties: "
cat 10.*.20.250 | egrep 'DHCP.*Automatic' | wc -l

for x in 3 4 5 6 7 8 9 10 11 12 13 14; do
        FILE="10.$x.20.250"
        if [ -r $FILE ] ; then
                echo -n "# --- Nr DHCP-leases op locatie $x (IP: $FILE): "
                cat $FILE | egrep 'DHCP.*Automatic' | wc -l
        else
                echo -n "# --- Nr DHCP-leases op locatie $x (IP: $FILE): "
                echo "-- (no file found)"
        fi
done

