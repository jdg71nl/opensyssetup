#!/bin/bash

FILE="$1"
if [[ -z "$FILE" ]]; then
  echo "Error: no filename provided"
  echo "Usage: $0 <file-name.c>"
  exit 1;
fi

# > FILE="example.tar.gz"
# > echo "${FILE%%.*}"
# example
# > echo "${FILE%.*}"
# example.tar
# > echo "${FILE#*.}"
# tar.gz
# > echo "${FILE##*.}"
# gz

BASE="${FILE%%.*}"
EXT="${FILE##*.}"

if [[ "$EXT" != "c" ]]; then
  echo "Error: extension is not .c"
  echo "Usage: $0 <file-name.c>"
  exit 1;
fi

echo "# running> gcc -o $BASE.bin $BASE.c -I."
gcc -o $BASE.bin $BASE.c -I.
chmod +x $BASE.bin

