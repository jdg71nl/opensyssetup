#!/bin/bash
#= sudo_check_cycle_wlan0.sh | updated: d231009
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
#
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
#
# if [ -f /home/jdg/semaphore_wlan0.active ]; then echo "# true" ; else echo "# false" ; fi
if [ ! -f /home/jdg/semaphore_wlan0.active ]; then
  MSG="semaphore says 'wlan0' is inactive, exiting .." 
  echo "# $MSG "
  logger "($BASENAME)# $MSG "
  exit 0
fi
#
#
CYCLE_PROG="/home/jdg/sudo_if_cycle_wlan0.sh"
IP="1.1.1.1"
#
if /usr/bin/fping -q -c3 $IP ; then
  MSG="# fping says host '$IP' is UP."
  echo "# $MSG "
  logger "($BASENAME)# $MSG "
else
  MSG="# fping says host '$IP' is DOWN ==> so will run:> $CYCLE_PROG ..."
  echo "# $MSG "
  logger "($BASENAME)# $MSG "
  $CYCLE_PROG
fi
#
#
# NOTE: install this cmd in CRONTAB:
# > cat /etc/crontab  | egrep sudo_check_cycle_wlan0
# */5  *  *  *  *  root  /home/jdg/sudo_check_cycle_wlan0.sh
#
#
exit 0
#
#-eof
