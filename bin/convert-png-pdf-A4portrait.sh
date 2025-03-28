#!/bin/bash
#= 
# (c)2024 John@de-Graaff.net
#
BASENAME=`basename $0`
usage() {
  echo "# usage: $BASENAME [ file.pdf ] " 1>&2
  exit 1
}
#
FILE="$1"
[[ -f "$FILE" ]] || usage
#
#convert -units PixelsPerInch -density $DPI $FILE $FILE.png
#convert $FILE $FILE.pdf
#
#
# https://stackoverflow.com/questions/70746166/how-to-convert-png-to-pdf-with-a4-dimensions-using-imagemagick
#
#: width=2400
#: length=$width*21/29.7
#: density=$width/29.7# pixel/cm
#: resize="$($width)x$($length)\!"
#: echo "# density = $density "
#: echo "# resize = $resize "
#
#magick convert $FILE $FILE.pdf
#magick convert $FILE -resize "%[papersize:A4]" $FILE.pdf
#
# - - - 
# https://askubuntu.com/questions/493584/convert-images-to-pdf
# https://github.com/myollie/img2pdf
# > brew install img2pdf
# from: https://github.com/myollie/img2pdf/blob/master/src/img2pdf.py
# img2pdf --output out.pdf --pagesize A4^T --border 2cm:2.5cm *.jpg
#
img2pdf --output "$FILE.pdf" --pagesize A4 --border 1cm:1.5cm "$FILE"
#
#-EOF
