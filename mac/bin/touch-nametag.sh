#!/bin/bash

# example: find . -type f -exec touch-nametag.sh "{}" \;

FILE=$1
if [[ -z "$FILE" ]]; then
	echo "Usage: $0 <file-name.ext>"
	echo "       format: <file-dYYMMDD-HHMM-name.ext>"
	echo "       will set the modified-time/date to YYMMDD HH:MM"
	echo "       format: <file-dYYMMDD-name.ext>"
	echo "       will set the modified-time/date to YYMMDD 08:00am"
	echo "       format: <file-dYYMM-name.ext>"
	echo "       will set the modified-time/date to YYMM01 01:00am"
	echo "       format: <file-dYY-name.ext>"
	echo "       will set the modified-time/date to YY0101 00:01am"
	exit 1;
fi

# sed sucks
#TAG=$( echo $FILE | sed 's/^d(.{6}).*$/\1/' )

#echo "testing format dYYMMDD-HHMM ..."
#TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{6})\-(\d{4}).*$/\1\2/" )
TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{6})\-(\d{4})[^\\\\\/]*$/\1\2/" )
TAGHM="${TAG}"

# if no tag 'dYYMMDD-HHMM' found, search for tag 'dYYMMDD'
if [[ "$FILE" == "$TAG" ]]; then
	#echo "testing format dYYMMDD ..."
	#TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{6}).*$/\1/" )
	TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{6})[^\\\\\/]*$/\1/" )
	TAGHM="${TAG}0800"
fi

# if no tag 'dYYMMDD' found, search for tag 'dYYMM'
if [[ "$FILE" == "$TAG" ]]; then
	#echo "testing format dYYMM ..."
	TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{4})[^\\\\\/]*$/\1/" )
	TAGHM="${TAG}010100"
fi

# if no tag 'dYYMM' found, search for tag 'dYY'
if [[ "$FILE" == "$TAG" ]]; then
	#echo "testing format dYY ..."
	TAG=$( echo "$FILE" | perl -pe "s/^.*?d(\d{2})[^\\\\\/]*$/\1/" )
	TAGHM="${TAG}01010001"
fi

if [[ "$FILE" == "$TAG" ]]; then
	echo "no datetag found in file: $FILE"
	exit 1;
fi

#echo "TAGHM=$TAGHM"
echo "touch -t $TAGHM '$FILE'"
touch -t $TAGHM "$FILE"

