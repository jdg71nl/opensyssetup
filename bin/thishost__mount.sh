#!/bin/bash
#
BASENAME=`basename $0`
#
# https://stackoverflow.com/questions/428109/extract-substring-in-bash
# > tmp=${a#*_}   # remove prefix ending in "_"
# > b=${tmp%_*}   # remove suffix starting with "_"
#
HOST=${BASENAME%__mount.sh*}
#
#: echo "# BASENAME = $BASENAME "
#: echo "# HOST     = $HOST "
#: # gives: 
#: # > ./thishost__mount.sh
#: # # BASENAME = thishost__mount.sh
#: # # HOST     = thishost
#: exit 0
#
# echo "# usage: $BASENAME [ -h hostname ] [ -r remote_dir] [ -l local_dir ] { -p port_nr } { -u username }" 1>&2 
#
mount_sshfs_here.sh -h $HOST 
#
#-eof

