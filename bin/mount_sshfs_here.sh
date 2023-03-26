#!/bin/bash
#= mount_sshfs_here.sh
# (c)2023 John@de-Graaff.net
#
# Note: on Mac install these apps from: https://osxfuse.github.io/
# - macFUSE 4.4.2 macOS 10.9 or later 
# - SSHFS   2.5.0 macOS 10.5 or later
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -h hostname ] [ -r remote_dir] [ -l local_dir ] { -p port_nr } { -u username }" 1>&2 
  exit 1
}
#
# MYID=$( id -u )
# if [ $MYID != 0 ]; then
#   #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ;
#   echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
# fi
#
# defaults
HOST=""
USER="jdg"
PORT="22"
RDIR=""
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
if [[ -z $HOST || -z $USER || -z $PORT || -z $RDIR || -z $LDIR ]]; then
  usage
fi
#
echo "# > mkdir -pv ${LDIR} "
mkdir -pv ${LDIR}
#
echo "# > sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${LDIR} "
#
sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${LDIR}
#
exit 0
#
