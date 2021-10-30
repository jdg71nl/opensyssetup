#!/bin/bash
# (c)2009 John de Graaff

# add in crontab:
# */1 * * * * root /usr/local/syssetup/bin/check_restart_ppp0.sh -check

DISABLEDFILE="/etc/check_restart_ppp0.disabled"
BASENAME=`basename $0`

usage() {
	echo "Usage: $BASENAME [-h] [-check] [-enable] [-disable]"
	echo "  -help    shows this help"
	echo "  -check   will check if ppp0 is up using wvdial, if not restart ppp0"
	echo "  -enable  will remove '/etc/check_restart_ppp0.disabled' and quit"
	echo "  -disable will create '/etc/check_restart_ppp0.disabled' and quit"
	exit 1
}
error_usage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

echo_msg_log() {
	echo "$1"
	logger "$1"
}

PARM="$1"
#[ -z "$PARM" ] && usage

case "$PARM" in
	-help)
		usage;
		;;
	-enable)
		rm -f $DISABLEDFILE
		echo_msg_log "$0 (PID:$$) removed file '$DISABLEDFILE'."
		exit 1
		;;
	-disable)
		touch $DISABLEDFILE
		echo_msg_log "$0 (PID:$$) created file '$DISABLEDFILE'."
		exit 1
		;;
	-check)
		# proceed after 'esac'
		;;
	*)
		usage;
		;;
esac

if test -f $DISABLEDFILE ; then
	echo_msg_log "$0 (PID:$$) disabled, file '$DISABLEDFILE' exists."
	exit 1;
fi

#echo "temp-exit" ; exit 1;

echo "$0 (PID:$$) started (options: '$*')"
PROG="wvdial"

PID=`pidof $PROG`
if test "$PID" != "" ; then
	echo "$PROG seems to be running (PID: $PID)..."
	#exit 0
fi
echo "$PROG is not running!"

#IP="80.69.65.224"
IP="87.253.135.10"
if /usr/bin/fping -q -c3 $IP ; then 
	echo "IP address '$IP' is reachable, concluding that ppp0 is up..."
	exit 0
fi

echo_msg_log "$0 (PID:$$): IP address '$IP' is NOT reachable -- Restarting $PROG now ..."

CMD="/sbin/ifdown ppp0"
echo_msg_log "$0 (PID:$$): executing cmd: $CMD "
$CMD

killall wvdial

sleep 10

CMD="/sbin/ifup ppp0"
echo_msg_log "$0 (PID:$$): executing cmd: $CMD "
$CMD

exit 0

