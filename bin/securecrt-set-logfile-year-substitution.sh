#!/bin/bash
#= securecrt-set-logfile-year-substitution.sh 
# (c)2024 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ filename ] " 1>&2 
  exit 1
}
#
FILE="$1"
if [[ ! -f "$FILE" ]]; then
        echo "Error: file '$FILE' does not exist"
        usage
fi
#
perl -pi -e "s/S:\"Log Filename V2\"=.*$/S:\"Log Filename V2\"=\/Users\/jdg\/Dropbox\/Cloud\/SecureCRT-logs\/d%y%M%D-%h%m--SSH--%H--%S--session.log/" "$FILE"
#
exit 0
#

