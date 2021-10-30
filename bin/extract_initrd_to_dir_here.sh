#!/bin/bash

INITRD="$1"
if [ ! -f "$INITRD" ]; then
	echo "Error: could not read file '$INITRD'"
	exit 1
fi

DIR=$(basename $INITRD)
echo "Creating directory '$DIR'"
mkdir -p "$DIR"
if [[ ! -d "$DIR" ]]; then
	echo "Error: could not create directory '$DIR'"
	exit 1
fi

echo "Extracting '$INITRD' to directory '$DIR'..."
cd "$DIR"
cat "$INITRD" | gunzip -c | cpio -i --make-directories --no-absolute-filenames
cd ..

echo "done"
exit

