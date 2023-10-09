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
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
CYCLE_PROG="/home/jdg/sudo_if_cycle_wlan0.sh"
IP="1.1.1.1"
#
if /usr/bin/fping -q -c3 $IP ; then
  echo "# fping says host '$IP' is UP."
else
  echo "# fping says host '$IP' is DOWN."
  echo "# (will run) > $CYCLE_PROG ..."
  $CYCLE_PROG
fi
#
exit 0
#
#-eof
