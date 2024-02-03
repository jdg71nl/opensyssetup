#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
echo "# > /sbin/route delete 10.220.0.0/16 10.77.66.133 "
/sbin/route delete 10.220.0.0/16 10.77.66.133
echo "# > /sbin/route delete 10.21.0.0/16 10.77.66.133 "
/sbin/route delete 10.21.0.0/16 10.77.66.133
#
echo "# "
#
exit 0
#
