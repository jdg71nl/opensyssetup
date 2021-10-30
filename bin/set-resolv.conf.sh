#!/bin/bash
# set-resolv.conf.sh
# will set the resolv.conf file from a command-line parameter (used from ifup scripts)
#
# Usage:
# set-resolv.conf.sh "search domain.com;nameserver 12.12.12.12;nameserver 13.13.13.13;"
#
# will convert ';' to newlines

echo "$1" | sed 's/;/\n/g' > /etc/resolv.conf

