#!/bin/bash

for FILE in *.AVI ; do \
	TAG="$(stat -f "%Sm" -t "d%y%m%d-%H%M" $FILE)"
	MP4="$TAG-$FILE.mp4"
	DST="/Users/jdg/Temp/$MP4"
	if [ -f "$DST" ] ; then
		echo "-- skipping \"$FILE\" because \"$DST\" already exists"
		touch -r "$FILE" "$DST"
	else
		echo "> /Users/jdg/Progs/HandBrakeCLI -i \"$FILE\" -o \"$DST\" --preset=\"Normal\""
		/Users/jdg/Progs/HandBrakeCLI -i "$FILE" -o "$DST" --preset="Normal"
		touch -r "$FILE" "$DST"
	fi
done;

