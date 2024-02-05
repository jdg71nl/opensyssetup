#!/bin/bash
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
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
#
#/sbin/ip route add 185.84.140.52/32 via 10.86.91.254
/sbin/ip route del 185.84.140.52/32 via 10.86.91.254
#
/sbin/ip route add 193.38.153.11/32 via 10.86.92.254
#/sbin/ip route del 193.38.153.11/32 via 10.86.92.254
#
#
exit 0
#
#-eof
