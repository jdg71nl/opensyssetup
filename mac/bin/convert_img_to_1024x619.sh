#!/bin/bash
#
# macOS> sudo port install imagemagick
#
# http://www.imagemagick.org/Usage/resize/
# Only Shrink Larger Images ('>' flag)
# Another commonly used option is to restrict IM so that it will only shrink images to fit into the size given.   Never enlarge.   This is the '>' resize option. Think of it only applying the resize to images 'greater than' the size given (its a little counter intuitive). 
#
for FILE in "$@" ; do
	/opt/local/bin/convert "$FILE" -resize 1024x619\> "$FILE-1024x619.png"
done


