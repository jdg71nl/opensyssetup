#!/bin/sh
egrep -B1 'subnet 1' /etc/dhcp3/dhcpd.conf | grep -v '\-\-' | perl -pe 's/^(# v.*)\n$/$1:\t/mg'

