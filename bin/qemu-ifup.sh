#!/bin/sh

#set -x

BR=$( echo "$0" | sed 's/^.*qemu-ifup-\(.*\)\.sh$/\1/' )
if [ "$BR" == "$0" ];then
	echo "Error: only start symlinks like qemu-ifup-br30.sh"
	exit 1
fi
#echo "BR=$BR"

switch=$BR

if [ -n "$1" ];then
        #/usr/bin/sudo /usr/sbin/tunctl -u `whoami` -t $1
        /usr/bin/sudo /sbin/ip link set $1 up
        sleep 0.5s
        /usr/bin/sudo /usr/sbin/brctl addif $switch $1
        exit 0
else
        echo "Error: no interface specified"
        exit 1
fi

