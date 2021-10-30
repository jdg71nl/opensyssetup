#!/bin/bash

# ---+------+------+----
BASENAME=`basename $0`
usage() {
        echo "Usage: $BASENAME [-h] [-check] [-enable] [-disable]"
        exit 1
}
error_usage() { echo "$1"; usage; }
error() { echo "$1"; exit 1; }
echo_msg_log() { echo "$1"; logger "$1"; }
#[ -z "$1" ] && usage
# ---+------+------+----


DISABLEDFILE="/var/run/dontcopy"

while [ true ]; do

	echo_msg_log "$BASENAME (PID:$$): starting while-loop again ..."

	if test -f $DISABLEDFILE ; then
		echo_msg_log "$BASENAME (PID:$$): file '$DISABLEDFILE' found!"
	else
		echo_msg_log "$BASENAME (PID:$$): running command ..."
		rsync -av /mnt/sdb1/data/20091219161210/ rsync://172.16.0.56/root/mnt/sdc1/tws-server-backup/20091219161210/
	fi

	sleep 30
done

