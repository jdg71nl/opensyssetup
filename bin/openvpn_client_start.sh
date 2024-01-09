#!/bin/bash
#= openvpn_client_start.sh 
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
#if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query "; fi
#
usage() {
  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
  echo "# usage: $BASENAME { config_name } " 1>&2 
  exit 1
}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
CONFIG_NAME="$1"
CONFIG_DIR="/etc/openvpn/$CONFIG_NAME"
CONFIG_FILE="$CONFIG_NAME.conf"
#
if [ -z "$CONFIG_NAME" ]; then 
  echo "# Error: no config_name provided. "
  usage
fi
#
if [ ! -d "$CONFIG_DIR" ]; then 
  echo "# Error: directory $CONFIG_DIR does not exist. "
  usage
fi
#
if [ ! -f "$CONFIG_DIR/$CONFIG_FILE" ]; then 
  echo "# Error: config-file $CONFIG_NAME does not exist. "
  usage
fi
#
#mkdir -pv /var/run/openvpn_client
#
# DOES NOT WORK:
#/usr/sbin/openvpn --writepid /var/run/openvpn_client/$CONFIG_NAME.pid --config $CONFIG_FILE --cd $CONFIG_DIR
#
cd $CONFIG_DIR
echo "# > /usr/sbin/openvpn --config $CONFIG_FILE --daemon "
/usr/sbin/openvpn --config $CONFIG_FILE --daemon
#
#
exit 0
#
#-eof
