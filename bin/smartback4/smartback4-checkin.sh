#!/bin/bash
#= smartback4-checkin.sh 

if [ `id -u` != 0 ]; then 
	# re-run as root:
	echo "# provide your password for 'sudo':"
	sudo "$0" "$*"
	#echo "ERROR: can only run this command as root .."
	exit 1
fi

# https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
# According to this page, $@ and $* do pretty much the same thing:
# - The $@ holds list of all arguments passed to the script. 
# - The $* holds list of all arguments passed to the script.
# They aren't the same. $* is a single string, whereas $@ is an actual array.


#/root/opensyssetup/bin/smartback4/smartback4-checkin.pl "$*"
/root/opensyssetup/bin/smartback4/smartback4-checkin.pl "$@"

#-eof
