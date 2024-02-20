#!/bin/bash
# Drop_File_Rename_for_Web.sh
# Create Automator script, Drop_File_Rename_for_Web.app, using "Run Shell Script", Pass_input=as_asrguments, copy/paste script therein.
#
for FILE in "$@" ; do
  NEW=$( echo "$FILE" | /usr/bin/perl -pe "s/[ ]+(-[ ]?)?/-/g" )
  mv "$FILE" "$NEW"
done
#-eof
