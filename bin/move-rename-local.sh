#!/bin/bash
#= move-rename-local.sh
# usage:
# > find . -type f -iname '*.jpg' | grep -vi thumb | sed 's/^\.\///' | grep '\/' | ./move-rename-local.sh
#
while read line ; do
  #echo "## $line ##"
  newfile=$( echo $line | sed 's/\//--/g' )
  echo "mv $line $newfile"
  mv $line $newfile
done
#
