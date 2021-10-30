#!/bin/sh

# check out: ssh-copy-id
#
# http://linux.die.net/man/1/ssh-copy-id

echo 
echo '-- creating and securing if not exists: $HOME/.ssh/authorized_keys ...'
mkdir -pv $HOME/.ssh
chmod -v 0700 $HOME/.ssh
echo touch $HOME/.ssh/authorized_keys
touch $HOME/.ssh/authorized_keys
chmod -v 0700 $HOME/.ssh/authorized_keys
echo 

echo '-- if you want to allow access from certain clients using pubkey-auth-method, copy their pubkeys to this machine:'
echo '-- on the SSH-client show the public key:'
echo 'cat $HOME/.ssh/id_rsa.pub'
echo '-- on this SSH-server, append it to this file:'
echo 'cat >> $HOME/.ssh/authorized_keys'
echo 
