#!/bin/bash
#= mac-route-show.sh
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
echo "# show route table on MacOS: "
echo "# > sudo netstat -nr -f inet "
netstat -nr -f inet
#
exit 0
#
