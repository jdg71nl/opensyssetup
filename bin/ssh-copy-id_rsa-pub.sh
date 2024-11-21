#!/bin/bash
#= ssh-copy-id_rsa-pub.sh 
#
echo "# running: ssh-copy-id_rsa-pub.sh ... "
#
# ssh-copy-id -i ~/.ssh/id_rsa.pub $1
#
echo "# running command: > ssh-copy-id -i ~/.ssh/id_rsa.pub $@"
ssh-copy-id -i ~/.ssh/id_rsa.pub $@
#
#-eof

