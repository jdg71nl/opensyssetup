#!/bin/bash
#= openssl_pipe_encrypt.sh

# usage:
# echo "my secret message" | openssl_pipe_encrypt.sh 

# # example usage:
# 
# > echo "hello123" | ./openssl_pipe_encrypt.sh 
# enter aes-256-cbc encryption password:
# Verifying - enter aes-256-cbc encryption password:
# U2FsdGVkX1/a4icHalOhQ1Od/JQEdxfwVJRyeKO1qEU=
# 
# > echo "U2FsdGVkX1/a4icHalOhQ1Od/JQEdxfwVJRyeKO1qEU=" | ./openssl_pipe_decrypt.sh                                       
# enter aes-256-cbc decryption password:
# hello123

# # idea from: https://jameshfisher.com/2017/03/09/openssl-enc/
# echo 'super secret message' > plain.txt
# openssl enc -k secretpassword123 -aes256 -base64 -e -in plain.txt -out cipher.txt
# cat plain.txt 
# cat cipher.txt 
# openssl enc -k secretpassword123 -aes256 -base64 -d -in cipher.txt -out plain_again.txt
# cat plain_again.txt

cat | openssl enc -aes256 -base64 -e 

# ---

# > openssl version
# LibreSSL 2.8.3
# 
# > openssl enc -h
# usage: enc -ciphername [-AadePp] [-base64] [-bufsize number] [-debug]
#     [-in file] [-iv IV] [-K key] [-k password]
#     [-kfile file] [-md digest] [-none] [-nopad] [-nosalt]
#     [-out file] [-pass arg] [-S salt] [-salt]
# 
#  -A                 Process base64 data on one line (requires -a)
#  -a                 Perform base64 encoding/decoding (alias -base64)
#  -bufsize size      Specify the buffer size to use for I/O
#  -d                 Decrypt the input data
#  -debug             Print debugging information
#  -e                 Encrypt the input data (default)
#  -in file           Input file to read from (default stdin)
#  -iv IV             IV to use, specified as a hexadecimal string
#  -K key             Key to use, specified as a hexadecimal string
#  -md digest         Digest to use to create a key from the passphrase
#  -none              Use NULL cipher (no encryption or decryption)
#  -nopad             Disable standard block padding
#  -out file          Output file to write to (default stdout)
#  -P                 Print out the salt, key and IV used, then exit
#                       (no encryption or decryption is performed)
#  -p                 Print out the salt, key and IV used
#  -pass source       Password source
#  -S salt            Salt to use, specified as a hexadecimal string
#  -salt              Use a salt in the key derivation routines (default)
#  -v                 Verbose
# 
# Valid ciphername values:
# 
#  -aes-128-cbc              -aes-128-cbc-hmac-sha1    -aes-128-cfb             
#  -aes-128-cfb1             -aes-128-cfb8             -aes-128-ctr             
#  -aes-128-ecb              -aes-128-gcm              -aes-128-ofb             
#  -aes-128-xts              -aes-192-cbc              -aes-192-cfb             
#  -aes-192-cfb1             -aes-192-cfb8             -aes-192-ctr             
#  -aes-192-ecb              -aes-192-gcm              -aes-192-ofb             
#  -aes-256-cbc              -aes-256-cbc-hmac-sha1    -aes-256-cfb             
#  -aes-256-cfb1             -aes-256-cfb8             -aes-256-ctr             
#  -aes-256-ecb              -aes-256-gcm              -aes-256-ofb             
#  -aes-256-xts              -aes128                   -aes192                  
#  -aes256                   -bf                       -bf-cbc                  
#  -bf-cfb                   -bf-ecb                   -bf-ofb                  
#  -blowfish                 -camellia-128-cbc         -camellia-128-cfb        
#  -camellia-128-cfb1        -camellia-128-cfb8        -camellia-128-ecb        
#  -camellia-128-ofb         -camellia-192-cbc         -camellia-192-cfb        
#  -camellia-192-cfb1        -camellia-192-cfb8        -camellia-192-ecb        
#  -camellia-192-ofb         -camellia-256-cbc         -camellia-256-cfb        
#  -camellia-256-cfb1        -camellia-256-cfb8        -camellia-256-ecb        
#  -camellia-256-ofb         -camellia128              -camellia192             
#  -camellia256              -cast                     -cast-cbc                
#  -cast5-cbc                -cast5-cfb                -cast5-ecb               
#  -cast5-ofb                -chacha                   -des                     
#  -des-cbc                  -des-cfb                  -des-cfb1                
#  -des-cfb8                 -des-ecb                  -des-ede                 
#  -des-ede-cbc              -des-ede-cfb              -des-ede-ofb             
#  -des-ede3                 -des-ede3-cbc             -des-ede3-cfb            
#  -des-ede3-cfb1            -des-ede3-cfb8            -des-ede3-ofb            
#  -des-ofb                  -des3                     -desx                    
#  -desx-cbc                 -gost89                   -gost89-cnt              
#  -gost89-ecb               -id-aes128-GCM            -id-aes192-GCM           
#  -id-aes256-GCM            -rc2                      -rc2-40-cbc              
#  -rc2-64-cbc               -rc2-cbc                  -rc2-cfb                 
#  -rc2-ecb                  -rc2-ofb                  -rc4                     
#  -rc4-40                   -rc4-hmac-md5            
 
#-EOF
