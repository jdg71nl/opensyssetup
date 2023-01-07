#!/bin/bash
# sudo config_replace_match_with_line.sh /etc/sysctl.conf 'fs.inotify.max_user_watches' 'fs.inotify.max_user_watches=524288'
#
FILE="$1"
MATCH="$2"
LINE="$3"
#
if [ -z "$LINE" ] ; then
  echo
  exit 99
fi
#
echo "# exec> perl -pi -e 's/^$MATCH.*$/$LINE/' $FILE "
perl -pi -e "'s/^$MATCH.*$/$LINE/'" $FILE 
#
#-eof

