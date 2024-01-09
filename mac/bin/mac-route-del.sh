#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
/sbin/route delete $1 $2
#
exit 0
#
