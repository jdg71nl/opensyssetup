#!/bin/bash
#
#bin="/opt/local/bin/convert"
bin="/usr/local/bin/convert"
#
for FILE in "$@" ; do
  $bin "$FILE" -resize 147x89\> "$FILE-147x89.png"
done


