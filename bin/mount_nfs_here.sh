#!/bin/bash
#= mount_nfs_here.sh
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -h hostname ] { -u username } { -p portnr } " 1>&2 
  exit 1
}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
# defaults
USER="jdg"
HOST=$1
PORT="22"
#
re_isa_num='^[0-9]+$'
re_isa_host='^[a-z0-9\-\.]+$'
re_isa_ip='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
#
while getopts ":u:h:p:" options; do
  case "${options}" in
    u)
      USER=${OPTARG}
      ;;
    h)
      HOST=${OPTARG}
      ;;
    p)
      PORT=${OPTARG}
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
#if [[ $HOST =~ '\/$' ]]; then
#  HOST=${HOST}
#fi
#
#       if ! [[ $YYYY =~ $re_isanum ]] ; then
#         echo "Error: YYYY must be a four-digit number."
#         usage
#       elif [ $YYYY -eq "0000" ]; then
#         echo "Error: YYYY must be greater than zero."
#         usage
#       fi
#       #
#
#       if ! [[ $MMDD =~ $re_isanum ]] ; then
#         echo "Error: MMDD must be a four-digit number."
#         usage
#       elif [ $MMDD -eq "0000" ]; then
#         echo "Error: MMDD must be greater than zero."
#         usage
#       fi
#       #
#       if ! [[ $HHMM =~ $re_isanum ]] ; then
#         echo "Error: HHMM must be a four-digit number."
#         usage
#       fi
#       #
#       #if [[ -z $SS ]] ; then
#       #fi
#       if ! [[ $SS =~ $re_isasec ]] ; then
#         echo "Error: SS must be a two-digit number."
#         usage
#       fi
#
DIR=${HOST}
PATH="/home/jdg"
#
echo "# command correct, executing .."
#
echo "# > /bin/mkdir -pv ${DIR} "
/bin/mkdir -pv ${DIR}
#
echo "# > /usr/bin/sudo /sbin/mount -t nfs -o resvport ${HOST}:${PATH} $DIR "
/usr/bin/sudo /sbin/mount -t nfs -o resvport ${HOST}:${PATH} $DIR
#
exit 0
#

#-EOF
