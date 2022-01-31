#!/bin/bash
#= openssl_pipe_decrypt.sh

# usage:
# echo "my_encrypted_base64_message" | openssl_pipe_decrypt.sh 
# openssl_pipe_decrypt.sh     (and after password copy-paste text)

openssl enc -aes256 -base64 -d -in /dev/stdin

#-EOF
