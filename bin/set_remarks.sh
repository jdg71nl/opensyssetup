#!/bin/bash
# (c)2009 John de Graaff

BASENAME=`basename $0`
usage() {
	echo "Usage: $BASENAME <file>":
	echo "  will replace '# ---'-lines with longer versions."
	exit 1
}
error_usage()  { echo "$1"; usage; }
error()        { echo "$1"; exit 1; }
echo_msg_log() { echo "$1"; logger "$1"; }

FILE="$1"
[ ! -f "$FILE" ] && error_usage "$BASENAME: ERROR: file '$FILE' does not exist!"

perl -pi -e 's/^# --.*$/# ------+++------------+++------------+++------------+++------------+++------------+++------/g' $FILE

