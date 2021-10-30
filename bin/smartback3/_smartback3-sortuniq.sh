#!/bin/bash
#= _smartback3-sortuniq.sh 

FILE=$1
[ ! -f "$FILE" ] && exit 1

TMP="$FILE.tmp"
[ -f "$TMP" ] && exit 1

touch "$TMP"
[ ! -f "$TMP" ] && exit 1

cat "$FILE" | sort | uniq | /usr/bin/perl -ne 'print if not /^\s*$/' > "$TMP"
cat "$TMP" > "$FILE"
rm "$TMP"

