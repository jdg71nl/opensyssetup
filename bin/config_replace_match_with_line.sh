#!/bin/bash
#
# sudo config_replace_match_with_line.sh /etc/sysctl.conf 'fs.inotify.max_user_watches' 'fs.inotify.max_user_watches=524288'
#
# https://www.sudo.ws/security/advisories/secure_path/
# # add sith visudo:
# Defaults editor=/usr/bin/vim
# Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/opensyssetup/bin"
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
echo "# exec> grep '$MATCH' $FILE "
grep "'$MATCH'" $FILE 
#
#-eof

