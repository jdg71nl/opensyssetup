#!/bin/bash
CRT=$1
echo "# file: $CRT"
openssl x509 -in "$CRT" -noout -text | egrep -A1 'Serial Number|Signature Algorithm|(Issuer|Subject):|Not (Before|After)' | perl -pe 's/^\s+//m' | egrep -v '^--|Validity|Subject Public Key Info'
echo
