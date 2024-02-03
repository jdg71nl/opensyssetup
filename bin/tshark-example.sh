#!/bin/bash
#
#MYID=$( id -u )
#if [ $MYID != 0 ]; then
#  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#fi
#
echo "# run on interface with capture-filter 'not ssh' (your current remote access prompt): "
echo "# > tshark -n -i enp1s0 -f \"not port 22\" "
#
