#!/bin/sh
DIR="$1"
find $DIR -type f -exec /usr/local/syssetup/bin/move_rename_dirfile_to_file.sh "{}" \;
