#!/bin/bash
#= sudo_if_cycle_wlan0.sh | updated: d231009
# (c)2023 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
#SCRIPT_PATH=`dirname $SCRIPT`
#
MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
#
# if [ -f /home/jdg/semaphore_wlan0.active ]; then echo "# true" ; else echo "# false" ; fi
if [ ! -f /home/jdg/semaphore_wlan0.active ]; then
  echo "# semaphore says 'wlan0' is inactive, exiting .." 
  exit 0
fi
#
echo "# ifdown wlan0 ..."
ifdown wlan0
echo "# sleep 1 ..."
sleep 1
echo "# ifup wlan0 ..."
ifup wlan0
#
exit 0
#
#-eof
