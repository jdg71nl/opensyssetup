#!/bin/sh
IP=$1
if [ "$IP" == "" ]; then
	echo "Usage: $0 <IP> [<PORT>]"
	exit
fi
PORT=$2
if [ "$PORT" == "" ]; then
	PORT=443
fi
echo "CMD> openssl s_client -verify 1 -showcerts -connect $IP:$PORT"
openssl s_client -verify 1 -showcerts -connect $IP:$PORT

