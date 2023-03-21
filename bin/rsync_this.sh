#!/bin/bash
#= rsync_this.sh
#set -o xtrace
#
# edit this:
SRC="/Users/jdg/Dropbox/JDGPRIVE/LB21/riool-breuk/"
FOLDER="/home/jdg/www/john.de-graaff.net/webroot/code/63097749/riool-breuk/"
#
SSH="jdg@jwww.j71.nl"
DST="$SSH:$FOLDER"
echo "# > rsync -v -rtlz --delete --delete-excluded --exclude='.DS_Store' -e 'ssh -p 2221' $SRC $DST "
rsync -v -rtlz --delete --delete-excluded --exclude='.DS_Store' --exclude='rsync_this.sh' -e 'ssh -p 2221' $SRC $DST
#-eof

