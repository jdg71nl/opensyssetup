#!/bin/bash
SIZE="1024x768"
FILE="$*"
echo "(cmd) mogrify -resize $SIZE $FILE"
mogrify -resize $SIZE "$FILE"

