#!/bin/bash
# (c)2008 John de Graaff

# add in crontab:
# cat /etc/crontab
# */5 * * * * root /usr/local/syssetup/bin/check_restart_ntp.sh

#debian:
# apt-get install ntpdate ntp

LOGGER=/usr/bin/logger

# dont log, this script is started every 1 minute
#MSG="$0 (PID:$$) started"
#echo $MSG
#$LOGGER "$MSG"

# if test "`/usr/local/syssetup/bin/ntpq-print-ip-synced-peer.sh`" != "" ; then echo jo ; else echo no ; fi

PEER="`/usr/local/syssetup/bin/ntpq-print-ip-synced-peer.sh`"

#if test "`pidof ntpd`" != "" ; 
#then
#	echo "ntpd seems to be running..."
#	exit 0
#fi

if test "$PEER" != "" ; 
then
	echo "ntpd is synced to '$PEER'"
	exit 0
fi

MSG="$0 (PID:$$): ntpd not synced, starting ntpdate ..."
echo $MSG
$LOGGER "$MSG"

# ---- ntpdate ------------------------------------------------

# ntp-pool.networkconcepts.nl = load-balanced:
# ntp1.networkconcepts.nl 89.106.162.2
# ntp2.networkconcepts.nl 89.106.163.2
# ntp3.networkconcepts.nl 80.69.65.224
# ntp4.networkconcepts.nl 84.244.144.194
#
# Additional options to pass to ntpdate
# -u     Direct  ntpdate  to  use an unprivileged port for outgoing packets.
# -b     Force the time to be stepped using the settimeofday() system call, rather than slewed (default) using the adjtime() system  call.  This  option should be used when called from a startup file at boot time.
# -s     Divert  logging  output  from  the  standard output (default) to the system syslog facility. This is designed primarily for convenience of cron scripts.

# binary
NTPDATE=/usr/sbin/ntpdate-debian
if [ ! -x $NTPDATE ]; then
	NTPDATE=/usr/sbin/ntpdate
fi
if [ ! -x $NTPDATE ]; then

	MSG="$0 (PID:$$): error, ntpdate was not found!"
	echo $MSG
	$LOGGER "$MSG"

	exit 0
fi

# jdg - dont source, will force known good NTP servers:
#
#if test -f /etc/default/ntpdate ; then
#	. /etc/default/ntpdate
#fi

# beter:
# idea from: /usr/sbin/ntpdate-debian
# if [ "$NTPDATE_USE_NTP_CONF" = yes ]; then
for f in /etc/ntp.conf.dhcp /etc/ntp.conf /etc/openntpd/ntpd.conf; do
	if [ -r "$f" ]; then
		file=$f
		break
	fi
done
if [ -n "$file" ]; then
	NTPSERVERS=$(sed -rne 's/^(servers?|peer) ([-_.:[:alnum:]]+).*$/\2/p' "$file" | grep -v '^127\.127\.' | tr "\n" " ") || ''
fi

# else: use known servers:
test -n "$NTPSERVERS" || NTPSERVERS="89.106.162.2 89.106.163.2 80.69.65.224 84.244.144.194 2.1.0.1"
test -n "$NTPOPTIONS" || NTPOPTIONS="-u"

MSG="$0 (PID:$$): using NTPSERVERS=$NTPSERVERS"
echo $MSG
$LOGGER "$MSG"

# ---- ntpd ------------------------------------------------

INIT=/etc/init.d/ntp-server
if [ ! -x $INIT ]; then
	INIT=/etc/init.d/ntp
fi
if [ ! -x $INIT ]; then
	
	MSG="$0 (PID:$$): error, ntp init script was not found!"
	echo $MSG
	$LOGGER "$MSG"

	exit 0
fi

# ---- restart ------------------------------------------------

CMD="$INIT stop"
MSG="$0 (PID:$$): executing cmd: $CMD "
echo $MSG
$LOGGER "$MSG"
$CMD

sleep 2

killall ntpd

sleep 2

CMD="$NTPDATE -b -s $NTPOPTIONS $NTPSERVERS"
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

