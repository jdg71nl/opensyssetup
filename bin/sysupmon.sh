#!/bin/bash

# sysupmon.sh
#
# runs at SysVInit (start/stop):
# /usr/local/bin/syssetup/sysupmon.sh startup
# /usr/local/bin/syssetup/sysupmon.sh shutdown
#
# run from crontab every 1 minute
# vi /etc/crontab
# */1 * * * * root /usr/local/bin/syssetup/sysupmon.sh

# MAXTIME: in seconds
MAXTIME=120

# DEBUG: 0 or 1
DEBUG=0

LOG="/var/log/sysupmon.log"
[[ ! -f $LOG ]] && touch $LOG

writeline() {
	echo -e "$NOWTIME\t($NOWDATE)\t$NOWSTATUS\t$DESCR" >> $LOG
	[[ $DEBUG -gt 0 ]] && echo -e "$NOWTIME\t($NOWDATE)\t$NOWSTATUS\t$DESCR"
	#if [[ $DEBUG -gt 0 ]]; then
	#	echo -e "$NOWTIME\t($NOWDATE)\t$NOWSTATUS\t$DESCR"
	#fi
}

removelastline() {
	LOGTMP="${LOG}.tmp"

	#jdg: on some old systems "head -n -1" is illigal, so need to calc lines...
	#head -n -1 "$LOG" > "$LOGTMP"

	NRLINES=`wc "${LOG}" | awk '{ print $1 }'`
	[[ $NRLINES == "" ]] && NRLINES=1
	[[ $DEBUG -gt 0 ]] && echo "NRLINES=$NRLINES"
	LINESMINUSONE=$(($NRLINES-1));
	[[ $DEBUG -gt 0 ]] && echo "LINESMINUSONE=$LINESMINUSONE"
	head -n $LINESMINUSONE "$LOG" > "$LOGTMP"

	mv "$LOGTMP" "$LOG"
}

OPT="$1"

# STATUS: START | RUNNING | STOP | HANGING
LASTLINE=`tail -n 1 $LOG`
LASTTIME=`echo "$LASTLINE" | awk -F "\t" '{ print $1 }'`
[[ $LASTTIME == "" ]] && LASTTIME=0
LASTSTATUS=`echo "$LASTLINE" | awk -F "\t" '{ print $3 }'`
[[ $LASTSTATUS == "" ]] && LASTSTATUS="STOP"

NOWTIME=`date +%s`
NOWDATE=`date`
DIFFTIME=$(( $NOWTIME - $LASTTIME ))

seconds=$DIFFTIME
days=$((seconds / 86400))
seconds=$((seconds % 86400))
hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))
DIFFFMT="$days::$hours:$minutes:$seconds (days::hours:minutes:seconds)"

[[ $DEBUG -gt 0 ]] && echo "LASTLINE=$LASTLINE"

if [ "$LASTSTATUS" == "START" -o "$LASTSTATUS" == "RUNNING" ]; then
	if [ $DIFFTIME -ge $MAXTIME ]; then
		# Last line was status before HANGUP!
		NOWSTATUS="HANGING"
		DESCR="System appeared to be hanging since last time!"
		writeline
		# dont exit: will write another line below
	fi
fi

if [ "$OPT" == "startup" -o "$OPT" == "start" ]; then
	NOWSTATUS="START"
	DESCR="System Startup (system was down for $DIFFTIME seconds, or $DIFFFMT)"
	[[ $LASTTIME == 0 ]] && DESCR="System Startup (first time)"
	writeline
	exit 0
fi

if [ "$OPT" == "shutdown" -o "$OPT" == "stop" ]; then
	UPTIME=`uptime`
	NOWSTATUS="STOP"
	DESCR="System Shutdown ('uptime' says: $UPTIME)"
	writeline
	exit 0
fi

case "$LASTSTATUS" in
START)
	NOWSTATUS="RUNNING"
	DESCR="System running..."
	writeline
	;;
RUNNING)
	# Normal operation: update last line with new time
	removelastline
	NOWSTATUS="RUNNING"
	DESCR="System running..."
	writeline
	;;
*)
	NOWSTATUS="RUNNING"
	DESCR="System running... (that's weird, last time it was down... I expected 'startup'"
	writeline
	;;
esac

exit 0

