#!/bin/bash
#= sudo_set_route_10.86-16_local.sh
# (c)2024 John@de-Graaff.net
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
#/sbin/ip route add 0.0.0.0/1   via 10.86.91.1
#/sbin/ip route add 128.0.0.0/1 via 10.86.91.1
#
#/sbin/ip route del 10.86.0.0/16 via 10.86.10.254
#
/sbin/ip route add 10.86.0.0/17 via 10.86.10.254 metric 20
/sbin/ip route add 10.86.128.0/17 via 10.86.10.254 metric 20
#
#
#-eof

