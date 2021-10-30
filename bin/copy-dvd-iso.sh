#!/bin/bash

# Debian/Ubuntu:
# apt install gddrescue

FILE=$1
if [ -z "${FILE}" ]; then
  FILE="dvd.iso"
fi

echo "# running command: "
echo "# > ddrescue --no-scrape /dev/dvd \"./${FILE}\" "
ddrescue --no-scrape /dev/dvd "./${FILE}"

#
