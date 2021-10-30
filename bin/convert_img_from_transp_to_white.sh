#!/bin/bash
#
#bin="/opt/local/bin/convert"
bin="/usr/local/bin/convert"
#
for FILE in "$@" ; do
  $bin "$FILE" -background white -alpha remove -alpha off "$FILE-white.png"
done


