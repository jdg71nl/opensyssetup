#!/bin/bash
#= sudopof == sudo poweroff
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
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
SUDOPOF_FILE="/root/opensyssetup/.sudopof.disabled"
#
if [ -e $SUDOPOF_FILE ]; then
  echo "# sudopof is DISABLED by this file: $SUDOPOF_FILE ..."
else
  /usr/sbin/poweroff 
fi
#
#-eof
