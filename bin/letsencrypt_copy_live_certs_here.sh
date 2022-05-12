#!/bin/bash
#= letsencrypt_copy_live_certs_here.sh 
# (c)2022 John@de-Graaff.net
#
BASENAME=`basename $0`
MYUID=$( id -u )
usage() {
  #echo "# usage: $BASENAME { auto | [ -y YYYY ] [ -m MM ] [ -d DD ] [-h HH ] [ -i MM ] [-s SS] } " 1>&2 
  echo "# usage: $BASENAME [hostname] " 1>&2 
  exit 1
}
if [ $MYUID != 0 ]; then
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 1 ;
fi
#
hostname=$1
if [ -z "$hostname" ]; then
  usage
fi
if [ ! -d /etc/letsencrypt/live/$hostname/ ]; then
  echo "# hostname '$hostname' does not exist"
  exit 1
fi
#
cat /etc/letsencrypt/live/$hostname/privkey.pem     > $hostname-privkey.pem
cat /etc/letsencrypt/live/$hostname/fullchain.pem   > $hostname-fullchain.pem
cat /etc/letsencrypt/live/$hostname/chain.pem       > $hostname-chain.pem
cat /etc/letsencrypt/live/$hostname/cert.pem        > $hostname-cert.pem
#
exit 0
#-eof
