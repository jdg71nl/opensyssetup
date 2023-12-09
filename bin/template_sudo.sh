#!/bin/bash
#= template_sudo.sh | updated: d231112
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
#
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
# https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
# According to this page, $@ and $* do pretty much the same thing:
# - The $@ holds list of all arguments passed to the script. 
# - The $* holds list of all arguments passed to the script.
# They aren't the same. $* is a single string, whereas $@ is an actual array.
#
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
#
# my statements here ...
#
#
exit 0
#
#-eof
