#!/bin/bash
DIR="$1"
if [[ ! -d "$DIR" ]]; then
	 echo "provide a directory!"
	 exit
fi
USER=root
GROUP=root
FMOD=644
DMOD=755
find "$DIR" -exec chown $USER.$GROUP "{}" \; -a \( -type f -exec chmod $FMOD "{}" \; \) -o \( -type d -exec chmod $DMOD "{}" \; -print \)

