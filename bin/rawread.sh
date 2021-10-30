#!/bin/sh

# idea from: http://www.troubleshooters.com/linux/coasterless.htm

if test "$1" = ""; then
        echo "Usage: rawread /dev/cdrom > file.iso"
        exit
fi

device=$1

cmd="isoinfo -d -i $device"

echo >&2
echo "starting to read ISO..." >&2
echo >&2
echo "cmd: $cmd" >&2
$cmd >&2
echo >&2

blocksize=`$cmd | grep "^Logical block size is:" | cut -d " " -f 5`
echo "blocksize = $blocksize" >&2

if test "$blocksize" = ""; then
        echo catdevice FATAL ERROR: Blank blocksize >&2
        exit
fi

blockcount=`$cmd | grep "^Volume size is:" | cut -d " " -f 4`
echo "blockcount = $blockcount" >&2

if test "$blockcount" = ""; then
        echo catdevice FATAL ERROR: Blank blockcount >&2
        exit
fi

echo >&2

# ori on website:
# command="dd if=$device bs=$blocksize count=$blockcount conv=notrunc,noerror"

command="dd if=$device bs=$blocksize count=$blockcount conv=notrunc"

echo "$command" >&2
$command
beep -r 1 -l 500 -d 5 -f 4000
