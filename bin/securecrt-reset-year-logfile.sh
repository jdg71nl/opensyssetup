#!/bin/bash
#= securecrt-reset-year-logfile.sh 
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -y YY ] [ filename ] " 1>&2 
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
FILE="$3"
if [[ ! -f "$FILE" ]]; then
        echo "Error: file '$FILE' does not exist"
        usage
fi
#
#echo "# command correct, exectuing .."
#
#echo perl -pi -e "s/S:\"Log Filename V2\"=.*$/S:\"Log Filename V2\"=\/Users\/jdg\/Dropbox\/Cloud\/SecureCRT-logs\/d$YY%M%D-%h%m--SSH--%H--%S--session.log/" "$FILE"
perl -pi -e "s/S:\"Log Filename V2\"=.*$/S:\"Log Filename V2\"=\/Users\/jdg\/Dropbox\/Cloud\/SecureCRT-logs\/d$YY%M%D-%h%m--SSH--%H--%S--session.log/" "$FILE"
#
exit 0
#

