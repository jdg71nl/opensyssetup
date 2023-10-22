#!/bin/bash
#= route_del_tunnel.sh | updated: d230928
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

## examples of /sbin/ip :
# /sbin/ip route add 193.70.40.1 dev eth0
# /sbin/ip route add default via 193.70.40.1
# /sbin/ip route add -net 10.0.0.0/8 dev lo
# /sbin/ip route del default via 193.70.40.1

## on local machine, this is OpenVPN config:
# > cat /etc/openvpn/dcs-gwclient/dcs-gwclient.conf | egrep ^remote
# remote 193.38.153.11 23121
# > ip route
# default via 10.86.91.254 dev vlan91 onlink 
# 10.86.10.0/24 dev br0 proto kernel scope link src 10.86.10.254 
# 10.86.91.0/24 dev vlan91 proto kernel scope link src 10.86.91.1 
# 10.86.92.0/24 dev vlan92 proto kernel scope link src 10.86.92.254 
# 10.86.93.0/24 dev vlan93 proto kernel scope link src 10.86.93.254 
# 10.86.94.0/24 dev vlan94 proto kernel scope link src 10.86.94.254 
# 10.231.0.0/16 via 10.231.21.24 dev tun21 
# 10.231.21.0/24 via 10.231.21.24 dev tun21 
# 10.231.21.24 dev tun21 proto kernel scope link src 10.231.21.23 
# 192.168.1.0/24 via 10.231.21.24 dev tun21 
# 192.168.1.60 via 10.231.21.24 dev tun21 
# 192.168.1.62 via 10.231.21.24 dev tun21 
# 192.168.1.65 via 10.231.21.24 dev tun21 

## on local machine, we have NAT:
# > cat /etc/iptables.conf | egrep tun21
# -A POSTROUTING -o tun21  -j MASQUERADE

## on cloud11 / OpenVPN-server:
#
# > ip addr show dev enp1s0  | egrep "enp1s0|inet "
# 2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
#    inet 193.38.153.11/29 brd 193.38.153.15 scope global enp1s0
#
# > cat /etc/iptables.conf | egrep enp1s0
# -A POSTROUTING -o enp1s0 -j MASQUERADE

## here we go:

# now lead generic-internet traffic (including DNS) throught OpenVPN tunnel:
/sbin/ip route del 0.0.0.0/1 dev tun21
/sbin/ip route del 128.0.0.0/1 dev tun21
#
# make sure the OpenVPN tunnel goes directly to (previous) Def.GW:
/sbin/ip route del 193.38.153.11 via 10.86.91.254
#
/sbin/ip route

#-eof

