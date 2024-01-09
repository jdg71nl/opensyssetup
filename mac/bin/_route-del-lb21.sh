#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
echo "# > /sbin/route delete 10.21.0.0/16 10.21.10.254 "
/sbin/route delete 10.21.0.0/16 10.21.10.254
#
echo "# > /sbin/route delete 192.168.178.0/24 10.21.10.254 "
/sbin/route delete 192.168.178.0/24 10.21.10.254
#
echo "# "
#
exit 0
#
