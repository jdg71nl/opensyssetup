#!/bin/bash
echo "(cmd:) /usr/bin/openssl x509 -text -noout -in '$1'"
/usr/bin/openssl x509 -text -noout -in "$1"

