#!/bin/bash

# named-update-slave_generic.sh 
SERVER=$( echo "$0" | sed 's/^.*named-update-slave_\(.*\)\.sh$/\1/' )
#SERVER="ns4.networkconcepts.nl"

case "$SERVER" in
	generic)
		echo "please run the symlink instead of generic"
		exit 1
	;;
esac

FILE="/etc/named-masterslavelist.txt"
GENERATE_CMD="/usr/local/syssetup/bin/generate-named.conf.pl"
RELOAD_CMD="/etc/init.d/bind9 reload"

cat $FILE | ssh -p2221 root@$SERVER "cat $FILE > $FILE.previous; cat > $FILE; $GENERATE_CMD; $RELOAD_CMD"

