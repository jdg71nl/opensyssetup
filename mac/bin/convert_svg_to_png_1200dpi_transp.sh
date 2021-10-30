#!/bin/bash
#
# https://wiki.inkscape.org/wiki/index.php/Using_the_Command_Line
# /Applications/Inkscape.app/Contents/MacOS/inkscape -?
#
bin="/Applications/Inkscape.app/Contents/MacOS/inkscape"
#
for FILE in "$@" ; do
	# $bin --export-type="png" 
	$bin --export-filename="$FILE-1200dpi.png" --export-area-page --export-background-opacity=0.0 --export-dpi=1200 "$FILE"
done


