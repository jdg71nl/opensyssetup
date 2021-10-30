#!/bin/bash

if test "$2" = ""; then
        echo "Usage: burniso scsidev file.iso"
        exit
fi

dev=$1
iso=$2

cmd="cdrecord -v speed=8 dev=$dev $iso"

echo >&2
echo "Starting to burn ISO '$iso' on device '$dev' ..." >&2
echo >&2
echo "cmd: $cmd" >&2
$cmd >&2
echo >&2

beep -r 1 -l 500 -d 5 -f 4000


##


