#!/bin/bash

IP=$1

if [[ -z "$IP" ]]; then
	echo "Usage: $0 <ip>"
	echo
	exit
fi

if [ -f "/etc/redhat-release" ]; then
	echo "Found OS-Type: Centos"
	CMD="sudo -u rancid -H /usr/local/rancid/bin/clogin $IP"
	echo "Running cmd: $CMD"
	$CMD

else
	if [ -f "/etc/debian_version" ]; then
		echo "Found OS-Type: Debian"
		CMD="sudo -u rancid -H /usr/lib/rancid/bin/clogin $IP"
		echo "Running cmd: $CMD"
		$CMD

	else
		echo "Unknown OS-Type !"
	fi

fi

