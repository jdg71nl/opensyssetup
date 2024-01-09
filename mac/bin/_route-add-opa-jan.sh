#!/bin/bash
#
#BASENAME=`basename $0`
#usage() {
#  echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -d MMDD ] [-h HHMM ] [-s SS] } " 1>&2 
#  exit 1
#}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
echo "# > /sbin/route add 10.220.0.0/16 10.77.66.133 "
/sbin/route add 10.220.0.0/16 10.77.66.133
echo "# > /sbin/route add 10.21.0.0/16 10.77.66.133 "
/sbin/route add 10.21.0.0/16 10.77.66.133
#
echo "# "
echo "# show route table on MacOS: "
echo "# > sudo netstat -nr -f inet "
echo "# "
echo "# remote these routes: "
echo "# > sudo /sbin/route delete 10.220.0.0/16 10.77.66.133 "
echo "# > sudo /sbin/route delete 10.21.0.0/16 10.77.66.133 "
echo "# "
#
exit 0
#
