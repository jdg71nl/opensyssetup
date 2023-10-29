#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ;  # DONT USE $* !!
  #echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
  #echo "# please run this as root" ; exit 1
  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
# echo "Press any key to continue"
# while [ true ] ; do
#   read -t 3 -n 1
#   if [ $? = 0 ] ; then
#     exit ;
#   else
#     echo "waiting for the keypress"
#   fi
# done
#
DEV=$1
#
echo "# "
echo "# to exit minicom (and leave serial console as it is), use: CRTL-A X "
echo "# Press any key to continue .."
echo "# "
echo "# > minicom --baudrate 9600 --noinit --ansi --wrap --statline --device ${DEV} ... "
echo "# "
read
#
minicom --baudrate 9600 --noinit --ansi --wrap --statline --device ${DEV}
#

