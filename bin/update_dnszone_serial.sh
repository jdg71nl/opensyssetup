#!/bin/bash

FILE="$1"
OLD_TAG=`cat "$FILE" | grep --max-count=1 -i serial | perl -pe 's/^.*?(\d{8})(\d{2}).*$/$1$2/'`
OLD_DATE=`  echo "$OLD_TAG" | perl -pe 's/^(\d{8})(\d{2})$/$1/'`
OLD_SERIAL=`echo "$OLD_TAG" | perl -pe 's/^(\d{8})(\d{2})$/$2/'`

echo "FILE='$FILE': OLD TAG=$OLD_TAG, DATE=$OLD_DATE, SERIAL=$OLD_SERIAL"

NEW_DATE=`date +%Y%m%d`
TIME=`date +d%y%m%d-%Hh%Mm%Ss`

NEW_SERIAL=`echo $OLD_SERIAL | perl -e '$O=<>; printf "%02d", ($O+1);'`
if [ "$OLD_DATE" != "$NEW_DATE" ]; then
	NEW_SERIAL="01"
fi;
NEW_TAG="$NEW_DATE$NEW_SERIAL"

echo "FILE='$FILE': NEW TAG=$NEW_TAG, DATE=$NEW_DATE, SERIAL=$NEW_SERIAL"

perl -pi -e 's/^(\s+)(\d{6,})\s*;.*?serial.*$/${1}'$NEW_TAG' ; serial in YYYYMMDDnn (last edit: '$TIME') /i' "$FILE";

