#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
/sbin/route delete 100.64.0.0/10
/sbin/route delete 10.0.0.0/8
#
exit 0
#
