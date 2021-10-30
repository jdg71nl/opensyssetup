#!/bin/sh

ARG=$1

# refresh PNG from someping:
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Veerallee > /dev/null 
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Leliestraat > /dev/null 
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Vismarkt > /dev/null 
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Rondweg > /dev/null 
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Wortmanstraat > /dev/null 
wget -q -O - http://172.20.240.1/cgi-bin/smokeping.cgi?target=Microwave.Noordweg > /dev/null 

BIN="/usr/bin/htmldoc"
DIR="/var/www/network-report/files"

MONTH=$( date +%m-%Y )
FILE="$DIR/deltaWonen-network-report-$MONTH.pdf"
URL="http://10.122.13.8/network-report/"

if [[ "$ARG" == "prev" ]]; then
	MONTH=$( /usr/local/syssetup/bin/print_previous_month.pl )
	TITLE=$( /usr/local/syssetup/bin/print_previous_month.pl --string )
	FILE="$DIR/deltaWonen-network-report-$MONTH.pdf"
	URL="http://10.122.13.8/network-report/?month='$TITLE'"
fi

$BIN --webpage --landscape --browserwidth 1500 --left 1cm --right 1cm --top 1cm -f $FILE $URL

