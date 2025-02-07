#!/bin/bash
# Drop_File_Rename_for_Web.sh
# Create Automator script, Drop_File_Rename_for_Web.app, using "Run Shell Script", Pass_input=as_asrguments, copy/paste script therein.

TIMESTAMP=$(date +d%y%m%d-%H%M%S)
LOGFILE="/Users/jdg/Downloads/Drop_File_Rename_for_Web.txt"
function dolog {
  # echo $1
  echo "$TIMESTAMP> $1" >> $LOGFILE
}

# Note: $* is a single string, whereas $@ is an actual array.
for FILE in "$@" ; do
  #
  # echo "# FILE    ='$FILE' "
  # 
  # NEW=$( echo "$FILE" | /usr/bin/perl -pe "s/[ ]+(-[ ]?)?/-/g" )
  #
  # FILENAME=$( basename $FILE )
  # DIRNAME=$( dirname $FILE )
  DIRNAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\1/g" )
  FILENAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\2/g" )
  BASENAME=$( echo "$FILENAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\1/g" )
  EXTENSION=$( echo "$FILENAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\2/g" )
  # echo "# DIRNAME ='$DIRNAME' "
  # echo "# FILENAME='$FILENAME' "
  # echo "# BASENAME='$BASENAME' "
  # echo "# EXTENSION='$EXTENSION' "
  #
  # https://perldoc.perl.org/perlre#/a-(and-/aa)  ==> /a modifier
  # https://perldoc.perl.org/5.8.1/perlre         ==> [[:print:]]
  # https://en.wikipedia.org/wiki/ASCII
  # NEW=$( echo "$FILENAME" | /usr/bin/perl -pe "s/[^0-9a-zA-Z\!\(\)\+,\-\.\/\:\;\=\?]/_/g" )
  NEW=$( echo "$BASENAME" | /usr/bin/perl -pe "s/[^0-9a-zA-Z!()+,\-.:;=?]/_/g" )
  #
  NEW=$( echo "$NEW" | /usr/bin/perl -pe "s/_{2,}/_/g" )
  NEW=$( echo "$NEW" | /usr/bin/perl -pe "s/_$//" )
  # NEW="$BASENAME"
  #
  # mv "$FILE" "$NEW"
  if [[ "$BASENAME" != "$NEW" ]]; then 
  #
    FILE_NEW="$DIRNAME/$NEW.$EXTENSION"
    # FILE_NEW="$FILE"
    #
    if [ -f "$FILE_NEW" ]; then
    # if [ true ]; then
      FILE_NEW="$DIRNAME/${NEW}_$TIMESTAMP.$EXTENSION"
    fi
    #
    # echo "# FILE_NEW='$FILE_NEW' "
    dolog "mv \"$FILE\" \"$FILE_NEW\""; 
    mv "$FILE" "$FILE_NEW" ; 
    #
  fi
done
#-eof
