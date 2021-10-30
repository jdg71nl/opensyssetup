#!/bin/bash

for FILE in "$@" ; do
	# need ImageMagick
	/opt/local/bin/convert "$FILE" -resize 2400x2400\> -format jpg "$FILE.jpg"
done

# next step? convert multiple PNG to create PDF:
# > convert *.png name.pdf

