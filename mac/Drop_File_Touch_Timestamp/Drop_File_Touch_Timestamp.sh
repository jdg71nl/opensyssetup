#!/bin/bash
# Drop_File_Touch_Timestamp.sh
# Howto:
# open Automator, new doc, Application, type "Run Shell Script", save-as Drop_File_Touch_Timestamp.app , pass-input=as-arguments, opy/paste contents of this .sh file

function dolog {
        echo $1
        echo "$(date +d%y%m%d-%H%M%S)> $1" >> "/Users/jdg/Downloads/Drop_File_Touch_Timestamp.txt"
}

for FILE in "$@" ; do

if [[ -d "$FILE" ]]; then TAG=$( date +%y%m%d-%H%M%S ) ; dolog "touch \"$FILE/d$TAG-file.txt\""; touch "$FILE/d$TAG-file.txt" ; continue ; fi

# bank periodic statements, filename example: 0587192089_001000CRC#RASF0_20120430_20120004.pdf
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?RASF0_20(\d{2}\d{2}\d{2})_[^\\\\\/]*$/\1/i" ) ; TAGHM="${TAG}0101"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# dYYMMDD-hhmmss
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?d(\d{6,8})\-(\d{4}\d{2})[^\\\\\/]*$/\1\2.\3/i" ) ; TAGHM="${TAG}"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# dYYMMDD-hhmm
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?d(\d{6,8})\-(\d{4})[^\\\\\/]*$/\1\2/i" ) ; TAGHM="${TAG}"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# dYYMMDD
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?d(\d{6})[^\\\\\/]*$/\1/i" ) ; TAGHM="${TAG}0101"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# dYYMM
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?d(\d{4})[^\\\\\/]*$/\1/i" ) ; TAGHM="${TAG}010101"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# YYYY-MM-DD
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?(\d{4})\-(\d{2})-(\d{2})[^\\\\\/]*$/\1\2\3/i" ) ; TAGHM="${TAG}0101"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

# YYYY-MM
TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?(\d{4})\-(\d{2})[^\\\\\/]*$/\1\2/i" ) ; TAGHM="${TAG}010101"
if [[ "$FILE" != "$TAG" ]]; then dolog "touch -t $TAGHM \"$FILE\""; touch -t $TAGHM "$FILE" ; continue ; fi

#TAG=$( echo "$FILE" | /usr/bin/perl -pe "s/^.*?d(\d{2})[^\\\\\/]*$/\1/i" ) ; TAGHM="${TAG}01010101"
#if [[ "$FILE" != "$TAG" ]]; then touch -t $TAGHM "$FILE" ; continue ; fi

dolog "touch \"$FILE\""
touch "$FILE"

done
 
# > cat /usr/local/syssetup/bin/touch-nametag.sh
#dolog "       format: <file-dYYYYMMDD-HHMMSS-name.ext>"
#dolog "       will set the modified-time/date to YYYYMMDD HH:MM:SS"
#dolog "       format: <file-dYYYYMMDD-HHMM-name.ext>"
#dolog "       will set the modified-time/date to YYYYMMDD HH:MM"
#dolog "       format: <file-dYYMMDD-HHMM-name.ext>"
#dolog "       will set the modified-time/date to YYMMDD HH:MM"
#dolog "       format: <file-dYYMMDD-name.ext>"
#dolog "       will set the modified-time/date to YYMMDD 01:01am"
#dolog "       format: <file-dYYMM-name.ext>"
#dolog "       will set the modified-time/date to YYMM01 01:01am"
#dolog "       format: <file-dYY-name.ext>"
#dolog "       will set the modified-time/date to YY0101 01:01am"
