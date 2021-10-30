#!/bin/bash

ID=`id -u`
[[ $ID -ne 0 ]] && echo "Run this command as root" && exit 1

# syssetup master
MASTER="vps1.de-graaff.net"
MASTERIP="91.184.11.145"

if grep -qi mac /etc/distro.info ; then 
	echo "test THISMACHINE==MASTER disabled on MacOS"
else
	if test "`ip addr|grep $MASTERIP`" != "" ; then
		echo "cant sync: you are on the master (IP=$MASTERIP, MASTER=$MASTER)"
		exit 0;
	fi
fi

logger "$0 started"
BAKDIR="/root/syssetup-rsync-backup/"
echo
echo "# rsync will run and make backups in dir '$BAKDIR' ..."
mkdir -pv $BAKDIR
rsync -rtlv --delete --backup --backup-dir=$BAKDIR -e "ssh -l syssetup" $MASTERIP:/usr/local/syssetup /usr/local/

