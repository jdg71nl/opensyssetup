#!/bin/bash
#= smartback3-add-ssh.sh

# general settings:
CONF_DIR="/etc/smartback3"
CONF_SH="$CONF_DIR/config.sh"
CLIENT_CONF="$CONF_DIR/client.sh"
FILELIST="$CONF_DIR/sources.txt"

[ -f "$CONF_SH" ] && source "$CONF_SH"

RSA_DIR="/root/.ssh"
RSA_ID="$RSA_DIR/id_rsa"
RSA_PUB="$RSA_DIR/id_rsa.pub"
if [ ! -f $HOME/.ssh/id_rsa ] ; then 
	echo "# setup new SSH RSA key in '$RSA_PUB' ..."
	echo 
	mkdir -pv $RSA_DIR
	chmod 0700 $RSA_DIR
	ssh-keygen -t rsa -f $RSA_ID -P '' 
fi

echo "# transfer SSH RSA key to SMARTBACK3 server ..."
echo 
#cat /root/.ssh/id_rsa.pub | ssh -p33022 smartback2@ipbackup.twsnet.net 'cat >> /home/smartback2/.ssh/authorized_keys'
echo "#> cat /root/.ssh/id_rsa.pub | ssh -p2221 smartback3@vps5.dgt-bv.com 'cat >> /home/smartback3/.ssh/authorized_keys' "
cat /root/.ssh/id_rsa.pub | ssh -p2221 smartback3@vps5.dgt-bv.com 'cat >> /home/smartback3/.ssh/authorized_keys'

# ------+++------
