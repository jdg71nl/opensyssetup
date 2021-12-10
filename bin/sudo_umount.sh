#!/bin/bash
#= sudo_umount.sh
# (c)2021 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ -h hostname ] " 1>&2 
  exit 1
}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ;
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
HOST=$1
#
# diskutil unmount force 
#
echo "# > /usr/bin/sudo /sbin/umount ${HOST} "
/usr/bin/sudo /sbin/umount ${HOST} 
#
exit 0
#

#-EOF
