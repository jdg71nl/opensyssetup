#!/bin/bash
find . -type f -exec rename_file_pattern.sh "{}" 's/[ ]+/-/g' \; 
exit 0

