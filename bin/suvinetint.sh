#!/bin/bash
#= suvinetint.sh
# (c)2021 John@de-Graaff.net
#
#BASENAME=`basename $0`
#usage() {
#  echo "# usage: $BASENAME [ -h hostname ] { -u username } { -p portnr } " 1>&2 
#  exit 1
#}
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
vi /etc/network/interfaces
#-EOF
