#!/bin/bash
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
#

# https://askubuntu.com/questions/309461/how-to-disable-ipv6-permanently/337736#337736
# add this section on the first line in this file:
# vi /boot/firmware/cmdline.txt 
# ipv6.disable=1

#-eof

