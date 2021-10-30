#!/bin/bash
echo "(cmd:) /usr/bin/openssl req -text -noout -in '$1'"
/usr/bin/openssl req -text -noout -in "$1"

