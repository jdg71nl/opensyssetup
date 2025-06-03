#!/bin/bash
THIS_SCRIPT_NAME="check_reset_linuxrouter.sh"
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
/usr/bin/logger "$THIS_SCRIPT_NAME: [start] "
#
if ! brctl show | egrep -q 'eth1' 2> /dev/null || ! brctl show | egrep -q 'wlan1' 2> /dev/null ; then
  /usr/bin/logger "$THIS_SCRIPT_NAME: now adding ifaces to brctl ..."
  brctl addif br0 eth1
  brctl addif br0 wlan1
fi
#
if ! systemctl is-active --quiet isc-dhcp-server.service 2> /dev/null ; then
  /usr/bin/logger "$THIS_SCRIPT_NAME: now restarting isc-dhcp-server ..."
  systemctl restart isc-dhcp-server.service
fi
#
#-eof

