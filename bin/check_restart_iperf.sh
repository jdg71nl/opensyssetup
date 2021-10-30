#!/bin/bash
# (c)2008 John de Graaff

# add in crontab:
# cat /etc/crontab
# */1 * * * * root /usr/local/syssetup/bin/check_restart_iperf.sh

LOGGER=/usr/bin/logger

# dont log, this script is started every 1 minute
#MSG="$0 (PID:$$) started"
#echo $MSG
#$LOGGER "$MSG"

if test "`pidof iperf`" != "" ; then
	echo "iperf seems to be running..."
	# dont log, this is started every minute...
	exit 0
fi

MSG="$0 (PID:$$): iperf not running, starting iperf..."
echo $MSG
$LOGGER "$MSG"

INIT=/etc/init.d/iperf-server
if [ ! -x $INIT ]; then
	
	MSG="$0 (PID:$$): error, iperf-server init script was not found!"
	echo $MSG
	$LOGGER "$MSG"

	exit 0
fi

CMD="$INIT stop"
MSG="$0 (PID:$$): executing cmd: $CMD "
echo $MSG
$LOGGER "$MSG"
$CMD

sleep 2

CMD="$INIT start"
MSG="$0 (PID:$$): executing cmd: $CMD "
echo $MSG
$LOGGER "$MSG"
$CMD

exit 0

