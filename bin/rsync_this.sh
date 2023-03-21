#!/bin/bash
#= rsync_this.sh
#set -o xtrace
#
# edit this:
SRC="/Users/jdg/Dropbox/FAIRFLOW/Incorporation/Restructure-2022/web/"
FOLDER="www/dgt-bv.com/webroot/code/28055838/fairflow-dgp-restructure-2022/"
#
SSH="jdg@jwww.j71.nl"
DST="$SSH:$FOLDER"
echo "# > rsync -v -rtlz --delete --delete-excluded --exclude='.DS_Store' -e 'ssh -p 2221' $SRC $DST "
rsync -v -rtlz --delete --delete-excluded --exclude='.DS_Store' -e 'ssh -p 2221' $SRC $DST
#-eof

