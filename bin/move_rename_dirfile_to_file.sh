#!/bin/bash

usage() {
	echo "Usage: `basename $0` dir1/dir2/file.ext" >&2
	echo "  Will move ./dir1/dir2/file.ext to ./dir1_dir2_file.ext"
	echo '  Example: find . -type f -exec move_rename_dirfile_to_file.sh "{}" \;'
	exit 1
}

errorusage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

[[ $# -eq 1 ]] || usage

file=$1

[[ -f $file ]] || errorusage "Error: '$isofile' not a regular file"

#remove leading dot
newfile1=$(echo "$file" | perl -pe 's/^\.\///')

# convert
newfile=$(echo "$newfile1" | perl -pe 's/[\\\/\:]/_/g')

[[ "$newfile1" == "$newfile" ]] || mv "$file" "$newfile"

exit 0

