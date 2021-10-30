#!/bin/bash

BASENAME=`basename $0`

usage() {
	echo "Usage: $BASENAME <domain name> <customer description>"
	exit 1
}
error_usage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

echo_msg_log() {
	echo "$1"
	logger "$1"
}

# > head default.zone
# ;CUSTOMER: none -- default zone file
# $ORIGIN default.net.

DOMAIN="$1"
FILE="$1.zone"
CUSTOMER="$2"

[ -z "$CUSTOMER" ] && usage
[ -f "$FILE" ] && error "Domein zone file '$FILE' already exists!"

cp default.zone "$FILE"

perl -pi -e "s/^\;CUSTOMER:.*$/;CUSTOMER: $CUSTOMER /"   "$FILE";
perl -pi -e 's/^\$ORIGIN.*$/\$ORIGIN '"$DOMAIN\./"       "$FILE";

update_dnszone_serial.sh "$FILE"

