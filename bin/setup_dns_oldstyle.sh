#!/bin/bash
#
ID=`id -u`
[[ $ID -ne 0 ]] && echo "Run this command as root" && exit 1
#
# first do as user 'jdg' !!
# sudo -u jdg -i
# cd
# mkdir -pv dev
# cd dev
# git clone --origin vps5 ssh://git@vps5.dgt-bv.com:2221/opt/git/dns-deploy.git    ./dns-deploy/
# git clone --origin vps5 ssh://git@vps5.dgt-bv.com:2221/opt/git/dns-de-graaffnet.git      ./dns-de-graaffnet/
#
if [ ! -d "/home/jdg/dev/dns-deploy" ] ;       then echo "dir not exist" ; exit 1; fi
if [ ! -d "/home/jdg/dev/dns-de-graaffnet" ] ; then echo "dir not exist" ; exit 1; fi
#
apt install opendnssec bind9utils libtemplate-perl
#
mkdir -pv /var/local/dns/
cd /var/local/dns/
ln -s /home/jdg/dev/dns-deploy/ .
ln -s /home/jdg/dev/dns-de-graaffnet/ dns-dgt
cd
ln -s /var/local/dns/dns-de-graaffnet/zones/ .

