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
  echo '#interface = wlan0' >> /etc/watchdog.conf
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

#- --[CWD=~]--[1699786400 11:53:20 Sun 12-Nov-2023 CET]--[root@rpi3b-erouter-vxb86s]--[hw:RPI3b-1.2,os:Raspbian-11/bullseye,kernel:6.1.21-v7+,isa:armv7l]------
#- > systemctl status watchdog.service 
#- ● watchdog.service - watchdog daemon
#-      Loaded: loaded (/lib/systemd/system/watchdog.service; enabled; vendor preset: enabled)
#-      Active: active (running) since Sun 2023-11-12 11:52:48 CET; 41s ago
#-     Process: 803 ExecStartPre=/bin/sh -c [ -z "${watchdog_module}" ] || [ "${watchdog_module}" = "none" ] || /sbin/modprobe $watchdog_module (code=exited, status=0/SUCCESS)
#-     Process: 804 ExecStart=/bin/sh -c [ $run_watchdog != 1 ] || exec /usr/sbin/watchdog $watchdog_options (code=exited, status=0/SUCCESS)
#-    Main PID: 806 (watchdog)
#-       Tasks: 1 (limit: 1595)
#-         CPU: 24ms
#-      CGroup: /system.slice/watchdog.service
#-              └─806 /usr/sbin/watchdog
#- 
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  interface: no interface to check
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  temperature: no sensors to check
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  no test binary files
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  no repair binary files
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  error retry time-out = 60 seconds
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  repair attempts = 1
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]:  alive=/dev/watchdog heartbeat=[none] to=root no_act=no force=no
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]: watchdog now set to 15 seconds
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl watchdog[806]: hardware watchdog identity: Broadcom BCM2835 Watchdog timer
#- Nov 12 11:52:48 rpi3b-erouter-vxb86s.j71.nl systemd[1]: Started watchdog daemon.
