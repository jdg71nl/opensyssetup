#!/bin/bash

# example: 
# find . -iname "crash*" -type f -exec ./touch-nametag-crash.sh "{}" \;


# crashinfo_20101025-075936

FILE="$1"
if [[ -z "$FILE" ]]; then
	echo "Usage: $0 <file-name.ext>"
	echo 
	echo "Example: find . -type f -exec touch-nametag-crash.sh \"{}\" \;"
	exit 1;
fi

if [[ ! -f "$FILE" ]]; then
	echo "File '$FILE' not found!"
	exit 1;
fi

TAG=$( echo "$FILE" | perl -pe "s/^.*?crashinfo_(\d{8})-(\d{4})(\d{2}).*?$/\1\2.\3/" )

if [[ "$FILE" == "$TAG" ]]; then
	echo "no datetag found in file: $FILE"
	exit 1;
fi

#echo "File=$FILE, TAG=$TAG"

# touch -t expects: [CC]YYMMDDHHMM.ss
echo "touch -t $TAG '$FILE'"

touch -t $TAG "$FILE"

