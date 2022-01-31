#!/bin/bash
#= openssl_pipe_encrypt.sh

# usage:
# echo "my secret message" | openssl_pipe_encrypt.sh 
# openssl_pipe_encrypt.sh   (and after password copy-paste text)

openssl enc -aes256 -base64 -e -in /dev/stdin

#-EOF
