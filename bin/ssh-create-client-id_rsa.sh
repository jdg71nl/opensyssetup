#!/bin/sh
mkdir -pv $HOME/.ssh
chmod 0700 $HOME/.ssh
if [ ! -f $HOME/.ssh/id_rsa ] ; then date > $HOME/.ssh/id_rsa.generate.txt ; ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P '' >> $HOME/.ssh/id_rsa.generate.txt; fi
#
echo "> cat \$HOME/.ssh/id_rsa.pub"
cat $HOME/.ssh/id_rsa.pub 
#
echo "# needed on server (which will allow a client based on the RSA key):"
echo "> touch      \$HOME/.ssh/authorized_keys"
echo "> chmod 0600 \$HOME/.ssh/authorized_keys"

