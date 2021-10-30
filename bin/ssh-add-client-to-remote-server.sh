#!/bin/bash
#= ssh-add-client-to-remote-server.sh 
# (c)2020 John@de-Graaff.net
# skeleton:
BASENAME=`basename $0`
usage() {
        echo "# usage: $BASENAME <USER> <HOST> [PORT=22]"
        echo "# - will add local .ssh/id_rsa.pub to remote .ssh/authorized_keys"
        exit 1
}
#error_usage()  { echo "# $BASENAME: ERROR - $1"; usage       ; }
#error()        { echo "# $BASENAME: ERROR - $1"; exit 1      ; }
#echo_msg_log() { echo "# $BASENAME: ERROR - $1"; logger "$1" ; }
#if [ `id -u` != 0 ]; then echo "Provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 1 ; fi
#
if [[ -z "$2" ]]; then usage ; fi
#
CFILE="~/.ssh/id_rsa.pub"
CFILE="$HOME/.ssh/id_rsa.pub"
SFILE=".ssh/authorized_keys"
USER="jdg"
USER="$1"
HOST="vps5.dgt-bv.com"
HOST="$2"
PORT="22"
if [[ -n "$3" ]]; then PORT="$3" ; fi
#
# # need to do before?
# > ssh git@vps5.dgt-bv.com 'mkdir -pv .ssh/ ; touch .ssh/authorized_keys' 
#
echo "# will-do> cat $CFILE | ssh -p $PORT $USER@$HOST 'cat >> .ssh/authorized_keys'"
cat $CFILE | ssh -p $PORT $USER@$HOST 'cat >> .ssh/authorized_keys'

