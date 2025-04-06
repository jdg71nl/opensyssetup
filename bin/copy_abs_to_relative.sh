#!/bin/bash

usage() {
	echo "Usage: $BASENAME <target-dir> <source-file1> <source-file2> <source-dir3> ..."
	exit 1
}
error_usage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

TARGET="$1"
if [ ! -d "$TARGET" ]; then
	echo "Error: could not read directory '$TARGET'"
	#exit 1
  usage
fi

# pop $1 from the list of source-files:
shift 

expand_source() {
	DIR=""
	FILE=""

	if [[ -f "$SOURCE" ]]; then
		DIR=$(dirname "$SOURCE")
		FILE=$(basename "$SOURCE")
	fi

	if [[ -d "$SOURCE" ]]; then
		DIR="$SOURCE"
	fi

	if [[ -z "$DIR" ]]; then
		echo "Error: could not read file or directory '$SOURCE'"
		exit 1
	fi

	ABS_DIR=$(cd $DIR; pwd)
	ABS_SOURCE="$ABS_DIR/$FILE"
}

#echo "Will copy these source files/dirs to the target:"
#for SOURCE in "$@"; do
#	expand_source "$SOURCE"
#	echo "* target: $TARGET < source: $ABS_SOURCE"
#done

#echo 
#echo "Are you sure ?"
#echo -n 'Press ENTER to continue, CTRL-C to abort...'
#read

# echo 
#echo "executing:"
for SOURCE in "$@"; do
  #
	#expand_source "$SOURCE"
  #
	#echo "find $ABS_SOURCE -type f -print0 | xargs -0i cp -rLv --preserve=mode,timestamps --parents {} $TARGET"
	#find "$ABS_SOURCE" -type f -print0 | xargs -0i cp -rLv --preserve=mode,timestamps --parents "{}" "$TARGET"
  #
	#echo "find $ABS_SOURCE -type f -o -type l -print0 | xargs -0i cp -rPv --preserve=mode,timestamps --parents {} $TARGET"
	#find "$ABS_SOURCE" -type f -o -type l -print0 | xargs -0i cp -rPv --preserve=mode,timestamps --parents "{}" "$TARGET"
  #
	echo "# > cp -rPv --preserve=mode,timestamps --parents \"$SOURCE\" \"$TARGET\"  ... "
	cp -rPv --preserve=mode,timestamps --parents "$SOURCE" "$TARGET"
  #
done


