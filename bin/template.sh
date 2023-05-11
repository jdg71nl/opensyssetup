#!/bin/bash
#= template.sh | updated: d220705
# (c)2022 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#
#MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#if [ $MYUID != 0 ]; then
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
#fi
#
#if [ -f ${SOME_FILE} ]; then
#else
#fi
#
# my statements here ...
#
exit 0
#
#-eof
