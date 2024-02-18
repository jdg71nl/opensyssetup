#!/bin/bash
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=\`dirname \$SCRIPT\`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .


# https://docs.couchdb.org/en/stable/install/unix.html#installation-using-the-apache-couchdb-convenience-binary-packages
# https://tecadmin.net/install-apache-couchdb-on-ubuntu/

# sudo apt install -y curl apt-transport-https gnupg 
f_check_install_packages ca-certificates curl gnupg wget apt-transport-https

curl https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1

source /etc/os-release 
echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ ${VERSION_CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/couchdb.list >/dev/null 

sudo apt-get update 

sudo apt-get install -y couchdb 



# - - - - - - = = = - - - - - - 
#
echo "# done!"
#echo "# check operation on: http://127.0.0.1:5984/_utils or http://172.16.222.132:5984/_utils/ "
#
#
. ~/opensyssetup/bin/set_env_ip_addresses.sh
#
echo "# check ops ==> http://127.0.0.1:5984/_utils "
if [ -n "$JINFO_IP_eth0" ]; then echo "# check ops ==> http://$JINFO_IP_eth0:5984/_utils " ; fi
if [ -n "$JINFO_IP_eth1" ]; then echo "# check ops ==> http://$JINFO_IP_eth1:5984/_utils " ; fi
if [ -n "$JINFO_IP_tun21" ]; then echo "# check ops ==> http://$JINFO_IP_tun21:5984/_utils " ; fi
if [ -n "$JINFO_IP_wlan0" ]; then echo "# check ops ==> http://$JINFO_IP_wlan0:5984/_utils " ; fi
if [ -n "$JINFO_IP_wlan1" ]; then echo "# check ops ==> http://$JINFO_IP_wlan1:5984/_utils " ; fi


#
#
exit 0
#
#-eof
