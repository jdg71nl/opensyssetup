#!/bin/bash
#= send_json_mqtt.sh
#
usage() {
 #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
 echo "# usage: $BASENAME { file.json } { my/topic/string } " 1>&2 
 exit 1
}
if [ -z "$2" ]; then
  usage;
fi
FILE="$1"
TOPIC="$2"
#
# sudo apt install jq
# DOS NOT WORK ?!?:  if [ ! hash jq 2>/dev/null ]; then
if ! which jq >/dev/null ; then
  echo "# Error: 'jq' not installed (to install use 'sudo apt install jq') "
  exit 1
fi
# EXTCONFS_PATH=`jq -r .extconfs_path $CFG_LEAP_CONFIG`
#
#
# NOW_EPOCH="123"
NOW_EPOCH=`date '+%s'`
# NOW_STRING="asdasd"
NOW_STRING=`date +%Y-%m-%d/%H:%M:%S/%Z%z`
#
# mosquitto_pub --url mqtt://downclient%mqtt-broker-name:tstpwd@127.0.0.1/v1/dcs-hopeland-python-mqtt-shim/devices/localhost/down/json_func_request -m '{"this":"is a test.","aux":{"topic":"v1/hopeland_mqtt_python_shim/localhost/down/json_func_request","topic_format":"$version/$application/$device/[up|down]/json_func_[request|response|push]"}}'
# 
#(on_message) topic=v1/hopeland_mqtt_python_shim/localhost/down/json_func_request qos=0 payload=b'{"function_name":"hopeland_tcp_client","args":{"command":"start","request_id":1705941109,"ip_address":"192.168.1.164"},"aux":{"time_epoch":1705941109,"time_string":"2024-01-22/17:31:49/CET+0100"}}'
# 
#BASE_URL='mqtt://downclient%mqtt-broker-name:tstpwd@127.0.0.1'
BASE_URL='mqtt://upclient%mqtt-broker-name:tstpwd@127.0.0.1'
TOPIC_URL="$BASE_URL/$TOPIC"
#
echo "# > mosquitto_pub --url $TOPIC_URL -m \"\$MESSAGE\" ..."
# echo "# > mosquitto_pub --url $TOPIC_URL -m \"$MESSAGE\" "
# exit 0
#
# https://jqlang.github.io/jq/manual/#builtin-operators-and-functions
cat $FILE | \
  tee /dev/fd/2 | \
  jq -jcM "setpath([\"args\",\"request_id\"];$NOW_EPOCH)" | \
  jq -jcM "setpath([\"aux\",\"time_epoch\"];$NOW_EPOCH)" | \
  jq -jcM "setpath([\"aux\",\"time_string\"];\"$NOW_STRING\")" | \
  tee /dev/fd/2 | \
  mosquitto_pub --url $TOPIC_URL -m "$(</dev/stdin)" 
  #
  # MESSAGE="$(</dev/stdin)"
  # mosquitto_pub --url $TOPIC_URL -m "$MESSAGE" 
  # cat
  # curl -X POST -H "Content-Type: application/json" -d "$(</dev/stdin)" http://localhost:1080/api/ttl_import
#
echo
echo "#. "
#
#-eof
