#!/bin/bash

# example: find . -type f -exec touch-nametag-ieder1.sh "{}" \;

# ieder1-bouwcam2-1008221400.jpg

FILE="$1"
if [[ -z "$FILE" ]]; then
	echo "Usage: $0 <file-name.ext>"
	echo "       format: ieder1-bouwcamX-YYMMDDHHMM"
	echo "       will set the modified-time/date to 20YY MM DD HH:MM"
	echo 
	echo "Example: find . -type f -exec touch-nametag-ieder1.sh \"{}\" \;"
	exit 1;
fi

if [[ ! -f "$FILE" ]]; then
	echo "File '$FILE' not found!"
	exit 1;
fi

# sed sucks
#TAG=$( echo $FILE | sed 's/^d(.{6}).*$/\1/' )

#echo "testing format dYYMMDD-HHMM ..."
#TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{6})\-(\d{4}).*$/\1\2/" )
TAG=$( echo "$FILE" | perl -pe "s/^.*?(\d{10}).*$/\1/" )

if [[ "$FILE" == "$TAG" ]]; then
	echo "no datetag found in file: $FILE"
	exit 1;
fi

#echo "File=$FILE, TAG=$TAG"

# touch -t expects: [CC]YYMMDDHHMM.ss
echo "touch -t $TAG '$FILE'"

touch -t $TAG "$FILE"

