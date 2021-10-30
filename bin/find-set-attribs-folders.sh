#!/bin/bash
# find-set-attribs-folders.sh

DMOD=$1

echo "$0 <DMOD> "
echo "    will to the following on all dirs/files from this directory and recurse:"
echo "- chmod dirs to $DMOD"
echo 
echo -n 'Press ENTER to continue, CTRL-C to abort...'
read

find . \
  \( -type d -exec chmod $DMOD "{}" \; -printf "%p \n" \) 
echo


