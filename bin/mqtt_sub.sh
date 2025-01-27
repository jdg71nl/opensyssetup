#!/bin/bash
#= mqtt_sub.sh
#
BASENAME=`basename $0`
# SCRIPT=`realpath -s $0`             # -s, --strip, --no-symlinks : don't expand symlinks
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
# echo "SCRIPT='$SCRIPT"            # SCRIPT='/Users/jdg/dev/mern-template/deploy/docker/dc-mongo-52-up.sh
# echo "SCRIPT_PATH='$SCRIPT_PATH"  # SCRIPT_PATH='/Users/jdg/dev/mern-template/deploy/docker
cd $SCRIPT_PATH
#
#. ./.pwd-export.sh 
#
MQTT_USER="some"
MQTT_PASS="some"
HOST="mqtt-broker.dge-ez.nl"
#
# HTTP
#PORT="1883"
#
# HTTPS
PORT="8883"
#
TOPIC="#"
#
# > apt install mosquitto
#
if [ "$PORT" == "1883" ]; then
  mosquitto_sub -h $HOST -p $PORT                         -u $MQTT_USER -P $MQTT_PASS -t $TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
fi
if [ "$PORT" == "8883" ]; then
  mosquitto_sub -h $HOST -p $PORT --capath /etc/ssl/certs -u $MQTT_USER -P $MQTT_PASS -t $TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
fi
#
#-eof
