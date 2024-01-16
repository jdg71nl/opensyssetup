#!/bin/bash
#= curl_post_json.sh
#
# curl -X POST -H "Content-Type: application/json" -d '{"my":"json"}' http://localhost/my_post_endpoint
# curl -X GET http://localhost/my_get_endpoint?key1=value1&key2=value2
#
usage() {
 #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
 echo "# usage: $BASENAME { -d '{"my":"json"}' } { http://localhost/my_post_endpoint } " 1>&2 
 exit 1
}
if [ -z "$1" ]; then
  usage;
fi
#
# https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
# $* is a single string, whereas $@ is an actual array.
#
echo "# > curl -X POST -H \"Content-Type: application/json\" $@ "
curl -X POST -H "Content-Type: application/json" $@
#
echo
echo "#."
#
#-eof
