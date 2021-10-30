#!/bin/bash
DIR="$1"
if [[ ! -d "$DIR" ]]; then
	 echo "provide a directory!"
	 exit
fi
#find "$DIR" -printf "[%y] %p\n" -exec chown samba.samba "{}" \; -a \( -type f -exec chmod 666 "{}" \; \) -o \( -type d -exec chmod 777 "{}" \; \)
#find "$DIR" -printf "." -exec chown samba.samba "{}" \; -a \( -type f -exec chmod 666 "{}" \; \) -o \( -type d -exec chmod 777 "{}" \; \)
#find "$DIR" -exec chown samba.samba "{}" \; -a \( -type f -exec chmod 666 "{}" \; \) -o \( -type d -exec chmod 777 "{}" \; \)
find "$DIR" -exec chown jdg.jdg "{}" \; -a \( -type f -exec chmod 666 "{}" \; \) -o \( -type d -exec chmod 777 "{}" \; -print \)

