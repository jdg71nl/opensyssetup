#!/bin/bash

DMOD=$1
FMOD=$2
EMOD=$3

if [[ -z "$EMOD" ]]; then
	DMOD="0777"
	FMOD="0666"
	EMOD="0777"
	echo
	echo "-- no parameters given, using defaults: DMOD=$DMOD FMOD=$FMOD EMOD=$EMOD ..."
fi

echo
echo "-- $0 <DMOD> <FMOD> <EMOD>"
echo "-- will 'chmod' all dirs/files from this directory and recurse:"
echo "   - chmod dirs to $DMOD"
echo "   - chmod files to $FMOD"
echo "   - chmod executable files to $EMOD"
echo 
echo -n '-- Press ENTER to continue, CTRL-C to abort...'
read

find . \( -type d -exec chmod $DMOD "{}" \; -printf "\n%p:" \) -o \
	\( \
		-type f -printf "." -a \
		\( \
			\( -iname '*.sh' -exec chmod $EMOD "{}" \; \) -o \
			\( -iname '*.pl' -exec chmod $EMOD "{}" \; \) -o \
			-exec chmod $FMOD "{}" \; \
		\) \
	\)
echo


