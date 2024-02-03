#!/bin/bash
#
#BASENAME=`basename $0`
#usage() {
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
echo "# > /sbin/route add 10.21.0.0/16 10.21.10.254 "
/sbin/route add 10.21.0.0/16 10.21.10.254
#
echo "# > /sbin/route add 192.168.178.0/24 10.21.10.254 "
/sbin/route add 192.168.178.0/24 10.21.10.254
#
echo "# "
echo "# show route table on MacOS: "
echo "# > sudo netstat -nr -f inet "
echo "# "
echo "# remove these routes: "
echo "# > sudo /sbin/route delete 10.21.0.0/16 10.21.10.254 "
echo "# "
#
exit 0
#
