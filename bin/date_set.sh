#!/bin/bash
#= date_set.sh
# (c)2020 John@de-Graaff.net
#
MYUID=$( id -u )
# 100x for user, 0 for root
echo "# UID is ${MYUID} "
# usage: if [ "${MYUID}" == 0 ]; then echo "# detect root user" ; fi
#
IS_DEBIAN_DERIVATIVE="$(which dpkg 2>/dev/null)"
# usage: 
if [ "${IS_DEBIAN_DERIVATIVE}" ]; then echo "# detected Debian derivative" ; fi
#
case "$(uname -s)" in
  Darwin)                         PLAT='MacOS' ;;
  Linux)                          PLAT='Linux' ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)  PLAT='Windows' ;;
  *)                              PLAT='Unknown' ;;
esac
echo "# detected platform '${PLAT}' "
# usage: if [ "${PLAT}" == "Linux" ]; then echo "# detected Linux" ; fi
if [ "${PLAT}" != "Linux" ]; then 
  echo "# Error: detected non-Linux: can't use this script !" 
  exit 1
fi
#
#
BASENAME=`basename $0`
usage() {
  # echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -d MMDD ] [-h HHMM ] [-s SS] } " 1>&2 
  echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -m MM ] [ -d DD ] [-h HH ] [ -i MM ] [-s SS] } " 1>&2 
  exit 1
}
#
if [ $MYUID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
# https://www.digitpage.com/disable-automatic-time-synchronization-ubuntu-18-04-lts/
# https://phoenixnap.com/kb/how-to-set-or-change-timezone-date-time-ubuntu
# timedatectl set-time 2019-04-10
# timedatectl set-time 21:45:53
SYS_FILE="/usr/bin/timedatectl"
#
if [ "$1" == "auto" ]; then
  #
  echo "# set to 'auto', executing: "
  #
  if [ -f ${SYS_FILE} ]; then
    echo "# > timedatectl set-ntp yes "
    timedatectl set-ntp yes
  else
    echo "# > systemctl start systemd-timesyncd "
    systemctl start systemd-timesyncd
  fi
  #
  exit 0
fi
#
YYYY="unset"
# MMDD="unset"
# HHMM="unset"
MM="unset"
DD="unset"
HH="unset"
II="unset"
#SS="unset"
SS="00"
re_isa_4dnum='^[0-9]{4}$'
re_isa_2dnum='^[0-9]{2}$'
#
while getopts ":y:d:m:h:i:s:" options; do
  case "${options}" in
    y) YYYY=${OPTARG} ;;
    # d)
    #   MMDD=${OPTARG}
    #   ;;
    m) MM=${OPTARG} ;;
    d) DD=${OPTARG} ;;
    # h)
    #   HHMM=${OPTARG}
    #   ;;
    h) HH=${OPTARG} ;;
    i) II=${OPTARG} ;;
    s) SS=${OPTARG} ;;
    :) echo "Error: -${OPTARG} requires an argument." ; usage ;;
    *) usage ;;
  esac
done
#
      if ! [[ $YYYY =~ $re_isa_4dnum ]] ; then
        echo "Error: YYYY must be a four-digit number."
        usage
      elif [ $YYYY -eq "0000" ]; then
        echo "Error: YYYY must be greater than zero."
        usage
      fi
      #
      # if ! [[ $MMDD =~ $re_isa_4dnum ]] ; then
      #   echo "Error: MMDD must be a four-digit number."
      #   usage
      # elif [ $MMDD -eq "0000" ]; then
      #   echo "Error: MMDD must be greater than zero."
      #   usage
      # fi
      # #
      # if ! [[ $HHMM =~ $re_isa_4dnum ]] ; then
      #   echo "Error: HHMM must be a four-digit number."
      #   usage
      # fi
      # #
      # #if [[ -z $SS ]] ; then
      # #fi
      # if ! [[ $SS =~ $re_isa_2dnum ]] ; then
      #   echo "Error: SS must be a two-digit number."
      #   usage
      # fi
#
echo "# command correct, exectuing .."
if [ -f ${SYS_FILE} ]; then
  echo "# > timedatectl set-ntp no "
  timedatectl set-ntp no
  sleep 1
  echo "# > timedatectl set-time ${YYYY}-${MM}-${DD} "
  timedatectl set-time ${YYYY}-${MM}-${DD}
  echo "# > timedatectl set-time ${HH}:${II}:${SS} "
  timedatectl set-time ${HH}:${II}:${SS}
else
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
  # date ${MMDD}${HHMM}${YYYY}.${SS}
  date ${MM}${DD}${HH}${II}${YYYY}.${SS}
fi
#
exit 0
#

