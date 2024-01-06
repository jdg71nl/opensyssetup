#!/bin/bash
#= securecrt-set-logfile-year-substitution-allfiles.sh 
# (c)2024 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME " 1>&2 
  exit 1
}
#
#BIN="/usr/local/syssetup/bin/securecrt-reset-year-logfile.sh"
#BIN="./securecrt-reset-year-logfile.sh"
BIN="./securecrt-set-logfile-year-substitution.sh"
#
find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions -type f -iname '__*' -prune -o -iname '*.ini' -print -exec $BIN "{}" \;
#
exit 0
#

