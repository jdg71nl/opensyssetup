#!/bin/bash
# file: x509-pfx-package.sh

cd /etc/letsencrypt/live/chr.qam-internet.nl/

cat privkey.pem   > chr.qam-internet.nl.1.key
cat cert.pem      > chr.qam-internet.nl.1.crt
cat chain.pem     > chr.qam-internet.nl.1.chain.pem
cat fullchain.pem > chr.qam-internet.nl.1.fullchain.pem 

cat chr.qam-internet.nl.1.key chr.qam-internet.nl.1.crt > chr.qam-internet.nl.1.key-crt.pem

# > openssl pkcs12 -export -in chr.qam-internet.nl.1.key-crt.pem -out chr.qam-internet.nl.1.pfx -name chr.qam-internet.nl
# Enter Export Password:
# Verifying - Enter Export Password:
# pwd in x.pwd.txt

#
