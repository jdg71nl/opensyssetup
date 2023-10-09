#!/bin/bash
#= _smartback4-expand.sh

# general settings:
. /etc/smartback4/config.sh

# source client settings (this system)
. $CLIENT_CONF

# print msg to screen@stderr and to syslog:
echo_msg_log() { 
	MSG="script $0 (PID:$$): $1"
	echo $MSG > /dev/stderr
	$LOGGER_BIN "$MSG"
}

# trap "{ rm -f "$FULLFILE"; exit 255; }" EXIT

echo -n "$0: expanding file/source list ... " >/dev/stderr

# update rsync-includes file
echo "# rsync includes file: $INCL_FILE" > $INCL_FILE
echo "+ /$TOUCH_FILE" >> $INCL_FILE
echo "+ /etc/" >> $INCL_FILE
echo "+ /etc/smartback4/" >> $INCL_FILE
#echo "+ /etc/smartback2/smartbackup.*.sysinfo.txt" >> $INCL_FILE
echo "+ /etc/smartback4/**" >> $INCL_FILE
echo "- /dev/***" >> $INCL_FILE
echo "- /sys/***" >> $INCL_FILE
echo "- /proc/***" >> $INCL_FILE
echo "- /tmp/***" >> $INCL_FILE
echo "- /lost+found/***" >> $INCL_FILE
echo "- *.exe" >> $INCL_FILE
echo "- */files/*.tgz" >> $INCL_FILE
#echo "+ *.sh" >> $INCL_FILE
echo "+ **/*.sh" >> $INCL_FILE
#echo "- **/chroot/***" >> $INCL_FILE

cat $FILELIST | $EXPAND_PL | sort | uniq >> $INCL_FILE
echo "- **" >> $INCL_FILE

# manual: cd /etc/smartback4/; cat $FILELIST | _smartback4-expand-filelist.pl | sort | uniq > rsync.includes.txt

echo "done!" >/dev/stderr

