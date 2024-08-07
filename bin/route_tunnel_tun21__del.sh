#!/bin/bash
#= route_tunnel_tun21__del.sh

TUN="tun21"
TUN_GW="193.38.153.11"
VIA="10.86.92.254"

/sbin/ip route del 0.0.0.0/1 dev $TUN
/sbin/ip route del 128.0.0.0/1 dev $TUN

/sbin/ip route del $TUN_GW via $VIA

/sbin/ip route

#-eof
