#!/bin/bash
MYID=$( id -u )
if [ $MYID != 0 ]; then
  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# https://unix.stackexchange.com/questions/32182/simple-command-line-http-server
sudo python3 -m http.server 80
#
