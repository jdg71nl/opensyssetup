#!/bin/bash
#= smartback4-checkin.sh 

if [ `id -u` != 0 ]; then 
	# re-run as root:
	echo "# provide your password for 'sudo':"
	sudo "$0" "$*"
	#echo "ERROR: can only run this command as root .."
	exit 1
fi

/root/opensyssetup/bin/smartback4/smartback4-checkin.pl "$*"

#-eof
