#!/bin/bash
#= curl_post_json_verbose.sh
#
JSON=$1
URL=$2
#
echo "# "
#echo "# cmd> curl -v -s -o - -X POST -H 'Content-Type: application/json' -d '$JSON' $URL 2>&1 | egrep -v 'TLS|bytes data' "
echo "# > curl -v -s -o - -X POST -H 'Content-Type: application/json' -d '$JSON' $URL "
echo "# "
#
curl -v -s -o - -X POST -H 'Content-Type: application/json' -d "'$JSON'" $URL 2>&1 | egrep -v 'TLS|bytes data' 
#
echo
echo "# "
#
#-eof

