#!/bin/bash

#ARGS="$*"

FILELIST="$1"
if [[ -z "$FILELIST" ]]; then
        echo "Usage: $0 <filelist.txt> [rsync-includes.txt]"
        echo "       will convert/expand filelist and write to rsync-includes.txt."
        echo "       if [rsync-includes.txt] is not provided then 'filelist.txt.rsync-includes.txt' will be used."
        exit 1;
fi

[[ -r "$FILELIST" ]] || echo "ERROR: file '$FILELIST' not readable!"
[[ -r "$FILELIST" ]] || exit 1

INCL_FILE="$2"
if [[ -z "$INCL_FILE" ]]; then
	INCL_FILE="$FILELIST.rsync-includes.txt"
fi

touch "$INCL_FILE"
[[ -w "$INCL_FILE" ]] || echo "ERROR: file '$INCL_FILE' not writable!"
[[ -w "$INCL_FILE" ]] || exit 1

EXPAND_BIN="/usr/local/syssetup/bin/expand-filelist-rsyncincludes.pl"

echo "# rsync includes file: $INCL_FILE" > $INCL_FILE
echo "- /dev/***" >> $INCL_FILE
echo "- /sys/***" >> $INCL_FILE
echo "- /proc/***" >> $INCL_FILE
echo "- /tmp/***" >> $INCL_FILE
echo "- /lost+found/***" >> $INCL_FILE
cat $FILELIST | $EXPAND_BIN | sort | uniq >> $INCL_FILE
echo "- **" >> $INCL_FILE

# example how to run rsync with this includes-file:
#
# rsync -v -rtlz --delete --delete-excluded --include-from=/root/filelist.txt.rsync-includes.txt / rsync://172.20.230.1/sbwrite/

# example of rsync target config:
# > cat /etc/rsyncd.conf 
# uid = 0
# gid = 0
# use chroot = no
# pid file = /var/run/rsyncd.pid
# [sbwrite]
#  path = /sbwrite/
#  read only = false
#  write only = false
#  hosts allow = 127.0.0.1, 172.16.0.0/12, 2.0.0.0/8



