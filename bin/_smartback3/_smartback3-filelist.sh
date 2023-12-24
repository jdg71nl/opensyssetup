#!/bin/bash
#= _smartback3-filelist.sh

LIST="/filesystem-root-list.txt.gz"
REFFILE="/tmp/$LIST"

touch -d "-1 day" $REFFILE

if [ $LIST -ot $REFFILE  ]; then
	echo -n "$0: creating file-list ... " >/dev/stderr
	find / \
	 -regextype egrep -regex '^/(dev|proc|media|mnt|sys|tmp|live-build|lost\+found|run).*' -prune -o \
	 -type l -printf "%010T@ [%32Tc] (%12s Bytes) %M %m %u %g %p -> %l\n" -o \
	 -printf "%010T@ [%32Tc] (%12s Bytes) %M %m %u %g %p\n" \
	| gzip -c \
	> $LIST
	echo "done!" >/dev/stderr
else
	echo "not needed (last update less than 1 day old)" >/dev/stderr
fi

