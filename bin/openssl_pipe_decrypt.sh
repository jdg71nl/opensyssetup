#!/bin/bash
#= openssl_pipe_decrypt.sh

# usage:
# echo "my_encrypted_base64_message" | openssl_pipe_decrypt.sh 

cat | openssl enc -aes256 -base64 -d

#-EOF
