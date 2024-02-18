#!/bin/bash
#= sudo_reboot.sh | updated: d230928
# (c)2023 John@de-Graaff.net
#
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#
MYUID=$( id -u )
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
perl -pi -e 's/^option domain-name-servers .*$/option domain-name-servers 1.1.1.1 , 1.0.0.1 ;/' /etc/dhcp/dhcpd.conf
echo "# replacing in /etc/dhcp/dhcpd.conf : option domain-name-servers 1.1.1.1 , 1.0.0.1 ; ... "
#
#perl -pi -e 's/^option domain-name-servers .*$/option domain-name-servers 10.86.91.254 ;/' /etc/dhcp/dhcpd.conf
#
service isc-dhcp-server restart
#
exit 0
#
#-eof
