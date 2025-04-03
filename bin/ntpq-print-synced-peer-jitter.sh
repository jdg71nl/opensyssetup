#!/bin/sh

#debian
#/usr/bin/ntpq
#centos
#/usr/sbin/ntpq

#ntpq -n -c peers 2>/dev/null  | /bin/grep '\*.* u ' | /usr/bin/perl -ne '$_=~/^\*([\w\.]*)/;print "$1\n";'

#: > ntpq -n -c peers 2>/dev/null  
#:      remote           refid      st t when poll reach   delay   offset  jitter
#: ==============================================================================
#:  0.debian.pool.n .POOL.          16 p    -   64    0    0.000   +0.000   0.001
#:  1.debian.pool.n .POOL.          16 p    -   64    0    0.000   +0.000   0.001
#:  2.debian.pool.n .POOL.          16 p    -   64    0    0.000   +0.000   0.001
#:  3.debian.pool.n .POOL.          16 p    -   64    0    0.000   +0.000   0.001
#: -158.101.221.122 193.79.237.14    2 u   67 1024  377   24.842   +0.954   0.734
#: +162.159.200.123 10.21.8.4        3 u  578 1024  377   14.668   +0.139   0.179
#: *178.215.228.24  189.97.54.122    2 u  759 1024  377   23.638   -0.018   0.296
#: -141.95.171.142  5.196.160.139    3 u  821 1024  377   18.613   +0.270   0.267
#: -162.159.200.1   10.25.8.4        3 u  452 1024  377   14.186   +0.212   0.165
#: +45.13.156.3     211.222.126.40   3 u  746 1024  377   14.926   -0.073   0.105

# https://paulroberts69.wordpress.com/2022/08/02/interpreting-ntpq-output/
# JITTER = indicates the difference in the offset measurement between two samples. This is an error-bound estimate. Jitter is a primary measure of the network service quality.

ntpq -n -c peers 2>/dev/null  | /bin/grep '^\*.* u ' | awk '{ print $10 }'

#-eof


