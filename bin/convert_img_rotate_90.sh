#!/bin/bash
#
#bin="/opt/local/bin/convert"
bin="/usr/local/bin/convert"
#
for FILE in "$@" ; do
  $bin "$FILE" -rotate 90 "$FILE-rot90.jpg"
done


