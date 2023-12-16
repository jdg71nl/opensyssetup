#!/bin/bash
#= securecrt-reset-allfiles.sh
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -y YY ] " 1>&2 
  exit 1
}
#
YY="unset"
re_isanum='^[0-9]{2}$'
#
while getopts ":y:" options; do
  case "${options}" in
    y)
      YY=${OPTARG}
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      usage
      ;;
    *)
      usage
      ;;
  esac
done
#
      if ! [[ $YY =~ $re_isanum ]] ; then
        echo "Error: YY must be a two-digit number."
        usage
      fi
#
#echo "# command correct, exectuing .."
#
#BIN="/usr/local/syssetup/bin/securecrt-reset-year-logfile.sh"
BIN="./securecrt-reset-year-logfile.sh"
#
find ~/Library/Application\ Support/VanDyke/SecureCRT/Config/Sessions -type f -iname '__*' -prune -o -iname '*.ini' -print -exec $BIN -y $YY "{}" \;
#
exit 0
#

