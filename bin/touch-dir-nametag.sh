#!/bin/bash

DIR="$1"
if [[ -z "$DIR" ]]; then
	echo "Usage: $0 <dir>"
	echo "       format: <YYYY-MM-DD with or without more text in dirname>"
	echo "       format: <YYYY_MM_DD with or without more text in dirname>"
	echo "       format: <dYYMMDD with or without more text in dirname>"
	echo "       will set the modified-time/date to YYYYMMDD 08:00am"
	echo 
	echo "Example: find . -type d -exec touch-dir-nametag.sh \"{}\" \;"
	exit 1;
fi

# search for 'YYYY-MM-DD' tag
TAG=$( echo "./$DIR" | perl -pe "s/^.*?\/(\d\d\d\d)[_\-](\d\d)[_\-](\d\d).*$/\1\2\3/" )
TAGHM="${TAG}0800"

# if no tag found, search for tag 'dYYMMDD'
if [[ "./$DIR" == "$TAG" ]]; then
        #TAG=$( echo "$DIR" | perl -pe "s/^.*?d(\d{6}).*$/\1/" )
        TAG=$( echo "./$DIR" | perl -pe "s/^.*?\/d(\d{6}).*$/\1/" )
        TAGHM="${TAG}0800"
fi

if [[ "./$DIR" == "$TAG" ]]; then
	echo "no datetag found in dir: '$DIR'"
	exit 1;
fi

echo "touch -t $TAGHM '$DIR'"
touch -t $TAGHM "$DIR"

