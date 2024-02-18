#!/bin/bash
#= ssh-add-client-to-remote-server_as-root.sh 
# (c)2020 John@de-Graaff.net
# skeleton:
BASENAME=`basename $0`
usage() {
        echo "# usage: $BASENAME <USER> <TUSER> <HOST> [PORT=22]"
        echo "# - will add local .ssh/id_rsa.pub to remote .ssh/authorized_keys"
        #echo "# - BUT .. login as user <USER:jdg> and do 'sudo -u <TUSER:git> cat ..' as Target-User"
        #echo "# - BUT .. login as user <USER:jdg> and do 'sudo cat >> /home/<TUSER:git>/.ssh/authorized_keys' as Target-User"
        echo "# - BUT .. login as user <USER:jdg> and do 'cat >> /home/<TUSER:git>/.ssh/authorized_keys' as Target-User"
        exit 1
}
#error_usage()  { echo "# $BASENAME: ERROR - $1"; usage       ; }
#error()        { echo "# $BASENAME: ERROR - $1"; exit 1      ; }
#echo_msg_log() { echo "# $BASENAME: ERROR - $1"; logger "$1" ; }
#if [ `id -u` != 0 ]; then echo "Provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ; fi
#
if [[ -z "$3" ]]; then usage ; fi
#
CFILE="~/.ssh/id_rsa.pub"
CFILE="$HOME/.ssh/id_rsa.pub"
SFILE=".ssh/authorized_keys"
USER="jdg"
USER="$1"
TUSER="git"
TUSER="$2"
HOST="vps5.dgt-bv.com"
HOST="$3"
PORT="22"
if [[ -n "$4" ]]; then PORT="$4" ; fi
#
# # need to do before?
# > ssh git@vps5.dgt-bv.com 'mkdir -pv .ssh/ ; touch .ssh/authorized_keys' 
#
echo "# will-do> cat $CFILE | ssh -p $PORT $USER@$HOST \"cat >> /home/$TUSER/.ssh/authorized_keys\""
cat $CFILE | ssh -p $PORT $USER@$HOST "cat >> /home/$TUSER/.ssh/authorized_keys"
#cat $CFILE | ssh -p $PORT $USER@$HOST "sudo cat >> /home/$TUSER/.ssh/authorized_keys"
#cat $CFILE | ssh -p $PORT $USER@$HOST "sudo -u $TUSER cat >> .ssh/authorized_keys"

