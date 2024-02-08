#!/bin/bash
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
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
# JDG: vlan91 = Wifi-Ethernet
# JDG: vlan92 = 4G-Odido-NL
# JDG: vlan93 = 4G-Bouygues-FR
#
#/sbin/ip route add 0/0 via 10.86.91.254
/sbin/ip route del 0/0 via 10.86.91.254
#
/sbin/ip route add 0/0 via 10.86.92.254
#/sbin/ip route del 0/0 via 10.86.92.254
#
#
exit 0
#
#-eof

# JDG: vlan91 = Wifi-Ethernet
# JDG: vlan92 = 4G-Odido-NL
# JDG: vlan93 = 4G-Bouygues-FR

## # JDG: vlan91 = Wifi-Ethernet
## iface vlan91 inet static
##   address 10.86.91.1
##   netmask 255.255.255.0
##   gateway 10.86.91.254
##   #post-up   /sbin/ip route add 0/0 via 10.86.91.254
##   #post-down /sbin/ip route del 0/0 via 10.86.91.254
## #
## # JDG: vlan92 = 4G-Odido-NL
## iface vlan92 inet static
##   address 10.86.92.1
##   netmask 255.255.255.0
##   #gateway 10.86.92.254
##   #post-up   /sbin/ip route add 0/0 via 10.86.92.254
##   #post-down /sbin/ip route del 0/0 via 10.86.92.254
## #
## # JDG: vlan93 = 4G-Bouygues-FR
## #.
