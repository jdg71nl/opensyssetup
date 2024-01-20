#!/bin/bash
#= ssh-X-jdg.sh
# (c)2024 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
#BASENAME=`basename $0`
#echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
usage() {
  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
  echo "# usage: $BASENAME { HOSTNAME|IP }" 1>&2 
  exit 1
}
#
USER="jdg"
HOST="$1"
#
if [ -z "$HOST" ]; then
  usage;
fi
#
echo "# > ssh -X $USER@$HOST "
ssh -X $USER@$HOST
#
exit 0
#
#-eof
