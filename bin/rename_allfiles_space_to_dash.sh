#!/bin/bash
find . -type f -exec rename_file_pattern.sh "{}" 's/[ ]+-[ ]+/-/g' \; 
find . -type f -exec rename_file_pattern.sh "{}" 's/[ ]+/-/g' \; 
find . -type f -exec rename_file_pattern.sh "{}" 's/[\-]{3,}/--/g' \; 
exit 0

