#!/bin/bash
#= ssh-copy-id_rsa-pub.sh 
#
# ssh-copy-id -i ~/.ssh/id_rsa.pub $1
ssh-copy-id -i ~/.ssh/id_rsa.pub $@
#
#-eof

