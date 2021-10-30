#!/bin/bash

# can use with:
# find -type f -iname "*.jpg" -exec move_rename_dirfile_to_file.sh {} \;

usage() {
	echo "Usage: `basename $0` ISO_file" >&2
	echo "  Will mount the ISO_file with loop-mount under a directory with same name."
	exit 1
}

errorusage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

[[ $# -eq 1 ]] || usage

isofile=$1

[[ -f $isofile ]] || errorusage "Error: '$isofile' not a regular file"

filetype=`file -b "$isofile"`
case $filetype in
  *"9660"*)
  		echo "Test: '$isofile' is a valid ISO 9660 file";;
  *)
  		errorusage "Error: file '$isofile' is not a valid ISO 9660 file";;
esac

tst=`mount|grep "$isofile"`
[[ "$tst" == "" ]] || error "Error: the file '$isofile' is already mounted."

isodir=`basename "$isofile" | sed 's/.iso$//i'`

tst=`mount|grep "$isodir"`
[[ "$tst" == "" ]] || error "Error: the directory '$isodir' is already in use by another mount."

[[ -d "$isodir" ]] || (echo "Now creating directory '$isodir'"; mkdir "$isodir")
[[ -d "$isodir" ]] || error "Error: unable to create directory '$isodir'"

echo "Now mounting..."
mount "$isofile" "$isodir" -o loop,ro
echo "Done!"
mount | grep "$isodir"

exit 0

