#!/bin/bash
myfile=$( realpath $0 )
#expected="/home/jdg/update_dns-deploy_reload.sh"
expected="/usr/local/syssetup/bin/update_dns-deploy_reload.sh"
deploydir="/var/local/dns/dns-deploy"
#
if [[ "$myfile" != "$expected" ]]; then
	echo "# ERROR: this script is not the expected path '$expected'"
	exit
fi
cd "$deploydir/"
#
echo "# running update_dns-deploy_reload.sh .."
#
echo "> sudo /usr/bin/git pull"
sudo /usr/bin/git pull
#
echo "> sudo rm /etc/bind/named.conf.options"
sudo rm /etc/bind/named.conf.options
#
#
echo "> sudo rm /etc/bind/named.conf.local"
sudo rm /etc/bind/named.conf.local
#
echo "> sudo cp /var/local/dns/dns-deploy/named.conf.options /etc/bind/named.conf.options"
sudo cp /var/local/dns/dns-deploy/named.conf.options /etc/bind/named.conf.options
#
echo "> sudo cp /var/local/dns/dns-deploy/named.conf.local   /etc/bind/named.conf.local"
sudo cp /var/local/dns/dns-deploy/named.conf.local   /etc/bind/named.conf.local
#
echo "> sudo service bind9 reload"
sudo service bind9 reload
#

