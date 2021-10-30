#!/bin/bash

# can get one switch:
# rancid-run.sh -r 192.168.254.2
# see: man rancid-run

ARGS="$*"

if [ -f "/etc/redhat-release" ]; then
	echo "Found OS-Type: Centos"
	CMD="sudo -u rancid -H /usr/local/rancid/bin/rancid-run $ARGS"
	echo "Running cmd: $CMD"
	$CMD

else
	if [ -f "/etc/debian_version" ]; then
		echo "Found OS-Type: Debian"
		CMD="sudo -u rancid -H /usr/bin/rancid-run $ARGS"
		echo "Running cmd: $CMD"
		$CMD

	else
		echo "Unknown OS-Type !"
	fi

fi

