#!/bin/bash
FILE="$1"
/usr/bin/vim "$FILE"
/usr/local/syssetup/bin/update_dnszone_serial.sh "$FILE"

