#!/bin/bash
#
# > cat /etc/passwd | grep radloguser
# radloguser:x:1005:1004:,,,:/home/radloguser:/usr/local/bin/radloguser.sh
#
# > cat /etc/logrotate.d/freeradius 
# /var/log/freeradius/*.log {
#	weekly
#	rotate 52
#	compress
#	delaycompress
#	notifempty
#	missingok
#	postrotate
#		/etc/init.d/freeradius reload > /dev/null
#		killall -u radloguser tail
#	endscript
# }
#
# restart tail after log file is rotated (and tail killed):
while [ true ]; do
	/usr/bin/tail -n200 -f /var/log/freeradius/radius.log | grep -v rmvscript
	sleep 2
done
#
