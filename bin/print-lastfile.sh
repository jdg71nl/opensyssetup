#!/bin/sh
cd "./$1" 2&>1 1>/dev/null
if test "$?" -eq "0"; then
	/bin/ls -1t | /usr/bin/head -n1
fi
