#!/bin/bash

PROG=`basename $0`
FILE=$1
TIME=`date +d%y%m%d-%Hh%Mm%Ss`
BAK="/tmp/$FILE.backup-$PROG.$TIME.bak"

cp -a "$FILE" "$BAK"
expand -t 3 $BAK > $FILE

