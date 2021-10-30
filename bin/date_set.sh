#!/bin/bash
#= date_set.sh
# (c)2020 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -d MMDD ] [-h HHMM ] [-s SS] } " 1>&2 
  exit 1
}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ;
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
if [ "$1" == "auto" ]; then
  echo "# set to 'auto', executing: "
  echo "# > systemctl start systemd-timesyncd "
  systemctl start systemd-timesyncd
  exit 0
fi
#
YYYY="unset"
MMDD="unset"
HHMM="unset"
#SS="unset"
SS="00"
re_isanum='^[0-9]{4}$'
re_isasec='^[0-9]{2}$'
#
while getopts ":y:d:h:s:" options; do
  case "${options}" in
    y)
      YYYY=${OPTARG}
      ;;
    d)
      MMDD=${OPTARG}
      ;;
    h)
      HHMM=${OPTARG}
      ;;
    s)
      SS=${OPTARG}
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
      if ! [[ $YYYY =~ $re_isanum ]] ; then
        echo "Error: YYYY must be a four-digit number."
        usage
      elif [ $YYYY -eq "0000" ]; then
        echo "Error: YYYY must be greater than zero."
        usage
      fi
      #
      if ! [[ $MMDD =~ $re_isanum ]] ; then
        echo "Error: MMDD must be a four-digit number."
        usage
      elif [ $MMDD -eq "0000" ]; then
        echo "Error: MMDD must be greater than zero."
        usage
      fi
      #
      if ! [[ $HHMM =~ $re_isanum ]] ; then
        echo "Error: HHMM must be a four-digit number."
        usage
      fi
      #
      #if [[ -z $SS ]] ; then
      #fi
      if ! [[ $SS =~ $re_isasec ]] ; then
        echo "Error: SS must be a two-digit number."
        usage
      fi
#
# date MMDDhhmm[[CC]YY][.ss]]
#
echo "# command correct, exectuing .."
echo "# > systemctl stop systemd-timesyncd "
systemctl stop systemd-timesyncd
sleep 1
#
# > man date
# DATE(1)                                                                                   User Commands
# SYNOPSIS
# date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
#
#echo "# > date ${MMDD}${HHMM}${YYYY} "
echo "# > date ${MMDD}${HHMM}${YYYY}.${SS} "
date ${MMDD}${HHMM}${YYYY}.${SS}
#
exit 0
#

