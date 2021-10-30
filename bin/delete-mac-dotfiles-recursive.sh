#!/bin/bash
echo 'find . -type f \( -name "._*" -o -name ".DS_Store" \) -exec rm -v "{}" \;'
find       . -type f \( -name "._*" -o -name ".DS_Store" \) -exec rm -v "{}" \;

