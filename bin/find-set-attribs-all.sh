#!/bin/bash
# find-set-attribs-all.sh

USER=$1
GROUP=$2
DMOD=$3
FMOD=$4
EMOD=$5

echo "$0 <USER> <GROUP> <DMOD> <FMOD> <EMOD>"
echo "    will to the following on all dirs/files from this directory and recurse:"
echo "- chown all files/dirs to (user/group): $USER.$GROUP"
echo "- chmod dirs to $DMOD"
echo "- chmod files to $FMOD"
echo "- chmod executable files to $EMOD"
echo 
echo -n 'Press ENTER to continue, CTRL-C to abort...'
read

find . \( -exec chown --no-dereference $USER.$GROUP "{}" \; \) -a \
	\( -type d -exec chmod $DMOD "{}" \; -printf "\n%p:" \) -o \
	\( \
		-type f -printf "." -a \
		\( \
			\( -iname '*.sh' -exec chmod $EMOD "{}" \; \) -o \
			\( -iname '*.pl' -exec chmod $EMOD "{}" \; \) -o \
			-exec chmod $FMOD "{}" \; \
		\) \
	\)
echo


