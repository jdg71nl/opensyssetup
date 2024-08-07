#!/bin/bash
#= route_tunnel_tun73__del.sh

TUN="tun73"
TUN_GW="185.84.140.52"
VIA="10.86.93.254"

/sbin/ip route del 0.0.0.0/1 dev $TUN
/sbin/ip route del 128.0.0.0/1 dev $TUN

/sbin/ip route del $TUN_GW via $VIA

/sbin/ip route

#-eof
