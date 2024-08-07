#!/bin/bash
#= route_tunnel_tun73__set.sh

TUN="tun73"
TUN_GW="185.84.140.52"
VIA="10.86.93.254"

# make sure tunnel goes directly to tunnel-endpoint:
/sbin/ip route add $TUN_GW via $VIA

# now lead generic-internet traffic (including DNS) through tunnel:
/sbin/ip route add 0.0.0.0/1 dev $TUN
/sbin/ip route add 128.0.0.0/1 dev $TUN
#
/sbin/ip route

#-eof
