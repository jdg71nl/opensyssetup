#!/bin/bash
#= jdg-prefs-apt.sh | updated: d231028
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
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
#if [ -f ${SOME_FILE} ]; then
#else
#fi
#
#
apt install -y git curl htop lsof vim minicom netcat arp-scan arping fping jq ntp openvpn rsync sudo wget
# 
# also (manual?): 
#
# apt install -y ifupdown net-tools vlan bridge-utils
# apt install -y x11-apps x11-utils 
# apt install -y build-essential 
# apt install -y build-essential dkms bc raspberrypi-kernel-headers
# apt install -y 
# apt install -y 
# apt install -y 
#
exit 0
#
#-eof
