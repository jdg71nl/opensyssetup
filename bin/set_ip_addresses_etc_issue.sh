#!/bin/bash
#= set_ip_addresses_etc_issue.sh
#
BASENAME=`basename $0`
# SCRIPT=`realpath -s $0`             # -s, --strip, --no-symlinks : don't expand symlinks
SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
# echo "SCRIPT='$SCRIPT"            # SCRIPT='/Users/jdg/dev/mern-template/deploy/docker/dc-mongo-52-up.sh
# echo "SCRIPT_PATH='$SCRIPT_PATH"  # SCRIPT_PATH='/Users/jdg/dev/mern-template/deploy/docker
cd $SCRIPT_PATH
#
#
ISSUE=$(node ./set_ip_addresses_etc_issue.js)
#
echo -e "$ISSUE \n" > /etc/issue
#
#
#-eof
