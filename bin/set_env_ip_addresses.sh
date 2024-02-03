#!/bin/bash
#
## dot-include this file:
# . ~/opensyssetup/bin/set_env_ip_addresses.sh
#
export JINFO_IP_eth0=$( ip -o -4 addr show eth0 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_eth1=$( ip -o -4 addr show eth1 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_wlan0=$( ip -o -4 addr show wlan0 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_wlan1=$( ip -o -4 addr show wlan1 | awk '{print $4}' | sed 's/\/.*$//' )
export JINFO_IP_tun21=$( ip -o -4 addr show tun21 | awk '{print $4}' | sed 's/\/.*$//' )
#
#-eof
