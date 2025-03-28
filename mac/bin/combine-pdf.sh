#!/bin/bash

# hint from: http://www.macosxhints.com/article.php?story=2003083122212228
# need gs (ghostscript)
# install Macports: http://www.macports.org/ 
# port install ghostscript

help() {
	echo "usage: $0 <out.pdf> <in-files.pdf>"
}

OUT="$1"
shift
FILES="$*"

if [[ -z "$OUT" ]]; then
	help
fi
if [[ -e "$OUT" ]]; then
	echo "file '$OUT' already exists!"
	help
fi

# d250328 gs sucks:
#echo "CMD> gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile='$OUT' $FILES"
#gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$OUT" $FILES

# d250328 this works like a charm:
# https://stackoverflow.com/questions/2507766/merge-convert-multiple-pdf-files-into-one-pdf

qpdf --empty --pages $FILES -- $OUT

#-eof

