#!/bin/bash
find . \( -type d -exec chmod a+r "{}" \; -printf "\n%p: " \) -o \( -type f -printf "." -exec chmod a+r "{}" \; \)
#-eof

