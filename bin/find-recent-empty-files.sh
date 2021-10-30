#!/bin/bash
echo ">find . -maxdepth 2 -type f -size 0 -mtime -2 -printf \"%010T@ [%Tc] (%10s Bytes) %p\n\""
find        . -maxdepth 2 -type f -size 0 -mtime -2 -printf "%010T@ [%Tc] (%10s Bytes) %p\n"

