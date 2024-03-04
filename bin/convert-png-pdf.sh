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
FILE=$1
[[ -f $FILE ]] || usage
#
#
#convert -units PixelsPerInch -density $DPI $FILE $FILE.png
convert $FILE $FILE.pdf
#
#-EOF
