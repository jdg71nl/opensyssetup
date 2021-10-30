#!/bin/bash
# ---
# compress syslog-collect-file
# ---
# cat /etc/crontab
# # every sunday 03:00am
# 0 3 * * 2 root /var/log/HOSTS/compress-hosts.sh

# Example: d101102-0300
D=`date +d%y%m%d-%H%M`

F="HOSTS.log.txt"
cd /var/log/HOSTS/
cat $F | gzip > $F.$D.gz
echo '' > $F
# ---
