#!/bin/bash
#= run_debian_ipv6_disable.sh | updated: d231201
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
#
# import LIB:
echo "# - - - - - - = = = - - - - - - "
echo "# importing lib:raspi-config ..."
# /usr/bin/raspi-config ==> parts from: raspi-config ==> https://github.com/RPi-Distro/raspi-config
# check:> diff -bur /usr/bin/raspi-config $HOME/opensyssetup/bin/raspi-config__deb12_bookworm.local-copy-edit.sh
#LIB="/usr/bin/raspi-config"
#LIB="./raspi-config.local-copy-edit.sh"
#LIB="$HOME/opensyssetup/bin/raspi-config.local-copy-edit.sh"
LIB="$HOME/opensyssetup/bin/raspi-config__deb12_bookworm.local-copy-edit.sh"
#
if [ ! -f $LIB ]; then
  echo "# Error: file '$LIB' not found."
  exit 1
fi
. $LIB
# default in this file: INTERACTIVE=True
INTERACTIVE=False
echo "# done."
echo "# "
#
#
#- # disable ipv6 on rpi:
#- #https://www.howtoraspberry.com/2020/04/disable-ipv6-on-raspberry-pi/
#- #
#- #> vi /etc/sysctl.conf
#- #net.ipv6.conf.all.disable_ipv6 = 1
#- #net.ipv6.conf.default.disable_ipv6 = 1
#- #net.ipv6.conf.lo.disable_ipv6 = 1
#- #
#- #sysctl -p
#- #
#- #
#- echo "# - - - - - - = = = - - - - - - "
#- echo "# Disabling IPv6 ..."
#- CONFIG="/etc/sysctl.conf"
#- set_config_var net.ipv6.conf.all.disable_ipv6 1 $CONFIG
#- set_config_var net.ipv6.conf.default.disable_ipv6 1 $CONFIG
#- set_config_var net.ipv6.conf.lo.disable_ipv6 1 $CONFIG
#- sysctl -p
#- echo "# done."
#- echo "# "
#
#
# https://askubuntu.com/questions/1289904/20-04-why-does-sysctl-conf-fail-to-disable-ipv6-on-the-main-interface
# 1.
# systemd-networkd will reset the disable_ipv6 sysctl to false during network device configuration if it believes ipv6 should be enabled.
# 2.
# Sadly, there are many myths about how to disable IPv6 on Ubuntu and the Ubuntu project itself hasn't provided a canonical solution going as far back as Ubuntu 16.04.
# The best solution that I've found so far is to modify the Kernel commandline via Grub and reboot the system. See here:
# https://askubuntu.com/a/337736/266
#
# 
# jdg: using NetworkManager
# https://linux.fernandocejas.com/docs/troubleshooting/disable-ipv6-using-network-manager
# > nmcli connection show
# > nmcli connection modify Example ipv6.method "disabled"
# > sudo systemctl restart NetworkManager
# > nmcli connection up Example
#
#
exit 0
#
#-eof

