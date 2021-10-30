#!/bin/bash

USER="$1"
PWD="$2"

if [[ -z "$2" ]]; then
	echo "Usage: $0 <username> <passwd>"
	exit 1
fi

IP="172.16.12.11"
BUSER="CN=flexvpnbinduser,OU=Speciale Gebruikers,DC=onc,DC=loc"
BPWD="some"
BASE="DC=onc,DC=loc"
GROUP="ONC-Laptop"

echo "> ldapsearch -h $IP -x -D \"$USER\"  -w xxx -b \"$BASE\" \"(sAMAccountName=$USER)\" memberOf sAMAccountName | egrep '^(dn|memberOf|sAMAccountName):'"
ldapsearch -h $IP -x -D "$USER"  -w $PWD  -b "$BASE" "(sAMAccountName=$USER)" memberOf sAMAccountName | egrep '^(dn|memberOf|sAMAccountName):'



