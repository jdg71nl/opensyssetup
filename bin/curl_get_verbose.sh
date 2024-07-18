#!/bin/bash
#= curl_get_verbose.sh
#
URL=$1
#
echo "# "
echo "# > curl -v -s -o - -X GET $URL "
echo "# "
#
#curl -v -s -o - -X GET $URL 2>&1 | egrep -v 'TLS|bytes data' 
curl -v -s -o - -X GET $URL | egrep -v '^\* ' 2>&1 | egrep -v '^[\*{}] '
#
echo
echo "# "
#
#-eof

