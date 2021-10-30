#!/bin/bash
#= md5sum-check-checkfile.sh

CHECKFILE="md5sum-checkfile.txt"
#
# man bash:   -f file    True if file exists and is a regular file.
#
if [ ! -f "${CHECKFILE}" ]; then
  echo "file '${CHECKFILE}' does not exist, exiting!"
  exit 1
fi

md5sum -c ${CHECKFILE}

#
