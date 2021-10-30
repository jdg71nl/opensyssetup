#!/bin/bash

BINDCONFIG="$1"
USER="$2"
PWD="$3"

if [[ -z "$3" ]]; then
	echo "Usage: $0 <bind-config-file> <username> <passwd>"
	echo
	echo "Example:> cat /root/ldaptest-bind.conf"
	echo "BUSER=\"CN=binduser,OU=Speciale Gebruikers,DC=company,DC=loc\""
	echo "BPWD=\"pwd\""
	echo "IP=\"172.16.12.11\""
	echo "BASE=\"DC=onc,DC=loc\""
	echo
	exit 1
fi

# source BIND config file:
. $BINDCONFIG

if [[ -z "$BUSER" ]]; then
	echo "unknown \$BUSER"
	exit 1
fi
if [[ -z "$BPWD" ]]; then
	echo "unknown \$BPWD"
	exit 1
fi

#GROUP="ONC-Laptop"

echo "> ldapsearch -h $IP -x -D \"$BUSER\"  -w $BPWD -b \"$BASE\" \"(sAMAccountName=$USER)\" memberOf sAMAccountName | egrep '^(dn|memberOf|sAMAccountName):'"
ldapsearch -h $IP -x -D "$BUSER"  -w $BPWD  -b "$BASE" "(sAMAccountName=$USER)" memberOf sAMAccountName | egrep '^(dn|memberOf|sAMAccountName):'



