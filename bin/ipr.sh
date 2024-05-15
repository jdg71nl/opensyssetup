#!/bin/bash
#= ipr.sh | updated: d220705
# (c)2024 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
#BASENAME=`basename $0`
#echo "# running: $BASENAME ... "
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
#SCRIPT_PATH=`dirname $SCRIPT`
#
#MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
echo_exit1() { echo $1 ; exit 1 ; }
#if [ $MYUID != 0 ]; then
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#fi
#
#if [ -f ${SOME_FILE} ]; then
#else
#fi
#
# some_cmd
# # exit if the last command failed
# if [ $? -ne 0 ]; then exit 1; fi
#
# my statements here ...
#
PLAT="error"
case "$(uname -s)" in
  Darwin)
    PLAT='MacOS'
    ;;
  Linux)
    PLAT='Linux'
    ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    PLAT='Windows' 
    ;;
  *)
    PLAT='Unknown' 
    ;;
esac
#echo "# PLAT=\"$PLAT\""
#
if [ $PLAT == "MacOS" ]; then
  sudo netstat -nr -f inet
else
  ip route
fi
#
exit 0
#
#-eof
