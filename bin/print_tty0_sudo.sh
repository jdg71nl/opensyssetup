#!/bin/bash
#= print_tty0_sudo.sh
# (c)2022 John@de-Graaff.net
#
BASENAME=`basename $0`
MYUID=$( id -u )
usage() {
  #echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -m MM ] [ -d DD ] [-h HH ] [ -i MM ] [-s SS] } " 1>&2 
  echo "# usage: $BASENAME " 1>&2 
  exit 1
}
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
cat >> /dev/tty0 
#
exit 0
#-eof
