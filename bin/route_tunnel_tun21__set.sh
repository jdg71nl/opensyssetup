#!/bin/bash
#= route_tunnel_tun21__set.sh

# display every line executed in this bash script:
set -o xtrace

TUN="tun21"
TUN_GW="193.38.153.11"
VIA="10.86.92.254"

# make sure tunnel goes directly to tunnel-endpoint:
/sbin/ip route add $TUN_GW via $VIA

# now lead generic-internet traffic (including DNS) through tunnel:
/sbin/ip route add 0.0.0.0/1 dev $TUN
/sbin/ip route add 128.0.0.0/1 dev $TUN
#
/sbin/ip route

#-eof
