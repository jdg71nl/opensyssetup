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
OS=""
DIST=""
if [ -e /etc/debian_version ]; then
  #
  #OS=$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')
  OS=$(cat /etc/issue | head -1 | awk '{ print $1 }')
  #
  # some Debians have jessie/sid in their /etc/debian_version
  # while others have '6.0.7'
  if grep -q '/' /etc/debian_version; then
    DIST=$(cut --delimiter='/' -f1 /etc/debian_version)
  else
    DIST=$(cut --delimiter='.' -f1 /etc/debian_version)
  fi
fi
echo "# OS='$OS' DIST='$DIST' "
if [ $OS != "Debian" ]; then
  echo "# Error: detected non-Debian, so exit ..."
  exit 1
fi
#
#
if [ $DIST == "12" ]; then
  echo "# > apt install -y git curl htop lsof vim minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate watchdog ... "
            apt install -y git curl htop lsof vim minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate watchdog
else
  echo "# > apt install -y git curl htop lsof vim minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate watchdog ... "
            apt install -y git curl htop lsof vim minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate watchdog
fi
#
# d231119 changes:
# Package netcat is a virtual package provided by:
#  netcat-openbsd 1.219-1
#  netcat-traditional 1.10-47
# You should explicitly select one to install.
# 
## also (manual?): 
#
# apt install -y ifupdown net-tools vlan bridge-utils
# apt remove dhcpcd5
#
# apt install -y x11-apps x11-utils 
# apt install -y build-essential 
# apt install -y build-essential dkms bc raspberrypi-kernel-headers
#
# apt install -y hostapd isc-dhcp-server dnsproxy
# apt install -y hostapd isc-dhcp-server dnsmasq-base
#
exit 0
#
#-eof
