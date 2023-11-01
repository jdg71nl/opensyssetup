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

#-eof

