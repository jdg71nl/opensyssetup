#!/bin/bash
#= debian_install_default_apt.sh
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
f_check_install_packages() { 
  for PKG in $@ ; do 
    if ! dpkg-query -l $PKG >/dev/null ; then 
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
      sudo apt install -y $PKG 
    fi
  done
}
# f_check_install_packages curl git sudo
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
if [ $OS != "Debian" && $OS != "Raspbian" ] ; then
  echo "# Error: detected non-Debian, so exit ..."
  exit 1
fi
#
#
if [ $DIST == "12" ]; then
  echo "# > apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog ... "
            apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat-openbsd arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog
else
  echo "# > apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog ... "
            apt install -y git curl apt-transport-https htop lsof iptables vim traceroute mtr minicom netcat         arp-scan arping fping jq ntp openvpn rsync sudo wget locate inetutils-telnet telnet watchdog
fi
#
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
# DON'T?: apt remove dhcpcd5
#
# apt install -y x11-apps x11-utils 
# apt install -y build-essential 
# apt install -y build-essential dkms bc raspberrypi-kernel-headers
#
# apt install -y lshw hwinfo inxi
#
# apt install -y hostapd isc-dhcp-server dnsproxy
# apt install -y hostapd isc-dhcp-server dnsmasq-base
#
exit 0
#
#-eof
