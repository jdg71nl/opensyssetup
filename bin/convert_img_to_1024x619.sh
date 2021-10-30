#!/bin/bash
#
#bin="/opt/local/bin/convert"
bin="/usr/local/bin/convert"
#
for FILE in "$@" ; do
  $bin "$FILE" -resize 1024x619\> "$FILE-1024x619.png"
done


