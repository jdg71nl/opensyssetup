#!/bin/bash
#= sudo_wpa_cli_scan.sh | updated: d231112
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
#
echo "# > sudo wpa_cli scan ..."
sudo wpa_cli scan
echo "# > sleep 3 ..."
sleep 3
#
#sudo wpa_cli scan_results
#
# allowed_sort_fields = ["bssid","freq","level","flags","ssid",]
sudo wpa_cli scan_results | egrep '^[]0-9a-f]{2}:' | ./wpa_cli_parse_sort.js level
#
# output:
# bssid / frequency / signal level / flags / ssid
# 74:da:38:67:a2:f6       2437    -75     [WPA2-PSK-CCMP][ESS]    kz44-direct-2G
# e4:5f:01:82:c4:7e       2437    -61     [WPA2-PSK-CCMP][ESS]    happy-camper-2g
#
# correct GREP ==> ... | egrep '^[]0-9a-f]{2}:'
#
exit 0
#
#-eof
