#!/bin/bash

echo "this script is disabled"
exit 1

#note: /etc/named.conf -s symlink to /var/named/chroot/etc/named.conf
cat /etc/named.conf > /etc/named-formatted.conf
/usr/bin/perl -pi -e 'if ($_=~/^\s*zone\s*("[^"]+")\s*(.*?(master|slave).*?)\s+("[^"]+")\s*(.*)$/) {$_=sprintf("zone %-38s %s %-38s %s\n",$1,$2,$4,$5)} ;' /etc/named-formatted.conf
cat /etc/named-formatted.conf > /etc/named.conf 


