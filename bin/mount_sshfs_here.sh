#!/bin/bash
#= mount_sshfs_here.sh
# (c)2023 John@de-Graaff.net
#
# (OLD) Note: on Mac install these apps from: https://osxfuse.github.io/
# - macFUSE 4.4.2 macOS 10.9 or later 
# - SSHFS   2.5.0 macOS 10.5 or later
#
# Note: on Debian Linux do:
# > apt install sshfs
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -h hostname ] [ -r remote_dir] [ -l local_dir ] { -p port_nr } { -u username }" 1>&2 
  exit 1
}
#
# MYID=$( id -u )
# if [ $MYID != 0 ]; then
#   #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;
#   echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
# fi
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sshfs >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> sudo apt install sshfs " ; fi
#
# static defaults:
HOST=""
USER="jdg"
PORT="22"
RDIR="."
LDIR=""
#
while getopts ":h:u:p:r:l:" options; do
  case "${options}" in
    h)
      HOST=${OPTARG}
      ;;
    u)
      USER=${OPTARG}
      ;;
    p)
      PORT=${OPTARG}
      ;;
    r)
      RDIR=${OPTARG}
      ;;
    l)
      LDIR=${OPTARG}
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
# dynamic defaults:
if [ -z $LDIR ]; then
  LDIR=$HOST
fi
#
if [[ -z $HOST || -z $USER || -z $PORT || -z $RDIR || -z $LDIR ]]; then
  usage
fi
#
PWD="$(pwd)"
FULLDIR="$PWD/$LDIR"
#echo "# PWD = $PWD "
#echo "# FULLDIR = $FULLDIR "
#exit 1
#
echo "# > mkdir -pv ${FULLDIR} "
mkdir -pv ${FULLDIR}
#
echo "# > sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${FULLDIR} "
#
sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${FULLDIR}
#
echo "# done! (unmount like this: > umount $FULLDIR ) "
#
exit 0
#
