#!/bin/bash

usage() {
	echo "Usage: `basename $0` maildir-file"
	echo "  Will copy the file (incl leading dirs) to /tmp/`basename $0`/DATE/ for backup"
	echo "  Will then remove all MIME attachments using renattach and retouch"
	echo "  Example: find -type f -name "[0-9][0-9]*" -size +2048k -print -exec `basename $0` \"{}\" \;" 
	exit 1
}

errorusage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

[[ $# -eq 1 ]] || usage

file="$1"

[[ -f "$file" ]] || errorusage "Error: '$isofile' not a regular file"

DATE=`date +d%y%m%d`
BACK="/tmp/`basename $0`/$DATE"
mkdir -p "$BACK"

/bin/cp -a --parents "$file" $BACK/

cat "$BACK/$file" | renattach -ad > "$file"

touch --reference="$BACK/$file" "$file"

exit 0

