#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
TARGET=$1
#
/sbin/route add 100.64.0.0/10 ${TARGET}
/sbin/route add 10.0.0.0/8 ${TARGET}
#
exit 0
#
