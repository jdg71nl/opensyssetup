#!/bin/sh

#debian
#/usr/bin/ntpq
#centos
#/usr/sbin/ntpq

ntpq -n -c peers 2>/dev/null  | /bin/grep '\*.* u ' | /usr/bin/perl -ne '$_=~/^\*([\w\.]*)/;print "$1\n";'

