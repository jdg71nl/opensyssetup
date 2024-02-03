#!/bin/bash
#= sudo_set_semi_route_10.86.91.1_do.sh | updated: d231112
# (c)2023 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#
MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
#
/sbin/ip route add 0.0.0.0/1   via 10.86.91.1
/sbin/ip route add 128.0.0.0/1 via 10.86.91.1
#
#
echo "# > /sbin/ip route "
/sbin/ip route
#
#-eof

