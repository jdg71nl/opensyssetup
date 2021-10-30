#!/bin/bash
#
for FILE in "$@" ; do
	openssl base64 -e -in "$FILE" -out "$FILE.b64.txt"
done


