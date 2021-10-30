#!/bin/bash
#= convert-pdf-png-100dpi.sh 
# (c)2021 John@de-Graaff.net
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
DPI="100"
#
convert -units PixelsPerInch -density $DPI $FILE $FILE.png
#
#-EOF
