#!/bin/bash
# (c)2009 John de Graaff

BASENAME=`basename $0`
usage() {
	echo "Usage: $BASENAME <file>":
	echo "  will add/replace the first line of the file with '# <filename>' "
	exit 1
}
error_usage()  { echo "$1"; usage; }
error()        { echo "$1"; exit 1; }
echo_msg_log() { echo "$1"; logger "$1"; }

FILE="$1"
[ ! -f "$FILE" ] && error_usage "$BASENAME: ERROR: file '$FILE' does not exist!"

BASENAME_FILE=`basename "$FILE"`
LINE="# $BASENAME_FILE"

#HEAD=`head -n1 "$FILE"`
#if [ "$HEAD" != "$LINE" ]; then

mv $FILE $FILE.tmp && echo "$LINE" > $FILE && cat $FILE.tmp >> $FILE && rm $FILE.tmp

