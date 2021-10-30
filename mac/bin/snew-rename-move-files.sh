#!/bin/bash

# example file/dir: 16-02-07/1454862586.jpg

function snewmove {

#if [[ -d "$FILE" ]]; then TAG=$( date +%y%m%d-%H%M%S ) ; dolog "touch \"$FILE/d$TAG-file.txt\""; touch "$FILE/d$TAG-file.txt" ; continue ; fi
#echo "$(date +d%y%m%d-%H%M%S)> $1" >> "/Users/jdg/Downloads/Drop File Touch Timestamp.txt"
#TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?RASF0_20(\d{2}\d{2}\d{2})_[^\\\\\/]*$/\1/i" ) ; TAGHM="${TAG}0101"
#if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

	FILE=$1
	NEW=$( echo "$FILE" | /usr/bin/perl -pe "s/^\.\/(\d{2})-(\d{2})-(\d{2})\/(.*)$/d\1\2\3--\4/" )
	if [[ "$FILE" != "$NEW" ]]; then
		echo "mv $FILE $NEW"
		mv "$FILE" "$NEW"
	fi
}

# find-exec cannot call function (only files):
# find . -type f -exec snewmove "{}" \; 

# http://stackoverflow.com/questions/4321456/find-exec-a-shell-function
find . -type f -iname '*jpg' -print0 | while IFS= read -r -d '' file; do snewmove "$file"; done


