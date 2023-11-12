#!/bin/bash
#= setup_rpi_typical_config.sh 

# do as 'root':
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi

# import LIB:
echo "# - - - - - - = = = - - - - - - "
echo "# importing lib:raspi-config ..."
# /usr/bin/raspi-config ==> parts from: raspi-config ==> https://github.com/RPi-Distro/raspi-config
#LIB="/usr/bin/raspi-config"
LIB="./raspi-config.local-copy-edit.sh"
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

# hdmi
#echo "# - - - - - - + + + - - - - - - - - - - - - + + + - - - - - - - - - - - - + + + - - - - - - "
echo "# - - - - - - = = = - - - - - - "
echo "# Enabling HDMI hotplug ..."
set_config_var hdmi_force_hotplug 1 $CONFIG
echo "# done."
echo "# "

# watchdog
# https://diode.io/blog/running-forever-with-the-raspberry-pi-hardware-watchdog
# echo 'dtparam=watchdog=on' >> /boot/config.txt
#echo "# - - - - - - + + + - - - - - - - - - - - - + + + - - - - - - - - - - - - + + + - - - - - - "
echo "# - - - - - - = = = - - - - - - "
echo "# Enabling Watchdog ..."
#
PKG="watchdog"
echo "# [check] if package '$PKG' is installed ... "
# if dpkg-query -l rsync ; then echo true ; else echo false ; fi
if dpkg-query -l $PKG ; then
  echo "# [check] package '$PKG' IS installed."
else
  #echo "# [check] package '$PKG' is NOT installed, ==> will install now ... "
  #echo "# > apt install -y $PKG "
  #apt install -y $PKG
  #
  echo "# [check] package '$PKG' is NOT installed, ==> please install manually (and update first) "
  exit 1
  #
fi
#
set_config_var dtparam=watchdog on $CONFIG
#
if egrep '^watchdog-device' /etc/watchdog.conf ; then
  echo "# skipping ... (watchdog looks already configured) "
else
  #
  echo "# configuring watchdog ... "
  #
  echo >> /etc/watchdog.conf
  echo '# jdg: idea from https://diode.io/blog/running-forever-with-the-raspberry-pi-hardware-watchdog ' >> /etc/watchdog.conf
  echo 'watchdog-device = /dev/watchdog' >> /etc/watchdog.conf
  echo 'watchdog-timeout = 15' >> /etc/watchdog.conf
  echo 'max-load-1 = 24' >> /etc/watchdog.conf
  echo 'interface = wlan0' >> /etc/watchdog.conf
  echo '# ' >> /etc/watchdog.conf
  echo >> /etc/watchdog.conf
  #
  systemctl enable watchdog
  systemctl start watchdog
  #systemctl status watchdog
  #
fi
#
echo "# done."
echo "# "

#-eof

