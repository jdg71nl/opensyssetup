#!/bin/bash
#
#bin="/opt/local/bin/convert"
bin="/usr/local/bin/convert"
#
for FILE in "$@" ; do
  $bin "$FILE" -rotate 270 "$FILE-rot270.jpg"
done


