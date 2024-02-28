#!/bin/bash
#= whatismyip.sh

#echo "wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
#wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

#url="http://89.106.162.3/pubtools/whatismyip.php"
#url="http://89.106.162.12/pubtools/whatismyip.php"
#cmd="wget -q -O - $url"
#cmd2=$cmd' | grep -i "Your IP is"'
#echo "cmd: $cmd2"
#$cmd | grep -i "Your IP is"

#echo "cmd> wget -q -O - http://89.106.162.12/"
#echo "cmd> wget -q -O - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php"

#echo "cmd> curl -o - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php"
#curl -o - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php

# > curl-cat https://dgt-bv.com/whatismyip.php
# <!-- usage: curl https://dgt-bv.com/whatismyip.php -->
# <pre>
# Your IP address is                : 80.100.229.147
# The DNS PTR-record for your IP is : jdglb21.xs4all.nl
# Local time on server is           : Mon, 08 Mar 2021 11:29:25 +0100
# Local time in Unix-Epoch seconds  : 1615199365
# </pre>
#
# > type curl-cat 
#curl-cat is aliased to `curl -fsL'
#
#
#curl -fsL https://dgt-bv.com/whatismyip.php
#
echo "# > curl -fsL https://j71.nl/whatismyip.php "
curl -fsL https://j71.nl/whatismyip.php
#
#
#-eof

