#!/bin/bash
# (c)2008 John de Graaff
# Idea from: http://openvpn.net/archive/openvpn-users/2007-01/msg00323.html

PIDFILE=$1
CMD="$2 $3 $4 $5 $6 $7 $8 $9"

# writting PID of this script-process to file in $1:
echo "$$" > $1

/usr/bin/logger "$0 (PID:$$): first-time start cmd: $CMD"

while [ true ]; do

        # echo "start and restart after exit: $CMD"
        $CMD

        SLEEPLEN=`/usr/bin/perl -e "print int(rand( 15 ) ) + 5"`
        # echo -e "\nSleeping $SLEEPLEN seconds ... and will then restart: $CMD"
        sleep $SLEEPLEN

        /usr/bin/logger "$0 (PID:$$): after exit, restarting cmd: $CMD"

done
#
