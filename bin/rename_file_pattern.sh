#!/bin/bash

usage() {
	echo "Usage: `basename $0` <filename> <pcre-pattern>"
	echo "  Will rename (mv) <filename> to <newfilename>"
	echo "  where newfilename = echo <filename> | perl -pe <pcre-pattern>"
	echo "  Example: find . -type f -iname '*d11*' -exec `basename $0` \"{}\" 's/d11/d12/' \; > rename.sh"
	exit 1
}

errorusage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

[[ $# -eq 2 ]] || usage

file="$1"
pattern="$2"

[[ -f $file ]] || errorusage "Error: '$file' not a regular file"

# convert
newfile=$(echo "$file" | perl -pe "$pattern")

[[ "$file" != "$newfile" ]] && echo mv \"$file\" \"$newfile\"

exit 0

