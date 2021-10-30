#!/bin/bash

KIND=$( echo "$0" | sed 's/^.*copy_to_syssetup_\(.*\)\.sh$/\1/' )
TARGET=/usr/local/syssetup/$KIND/

SOURCE="$1"
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
	echo "Provide a file or directory!"
	exit 1
fi

ABS_DIR=$(cd $DIR; pwd)
ABS_SOURCE="$ABS_DIR/$FILE"

find "$ABS_SOURCE" -type f -print0 | xargs -0i cp -rLv --preserve=mode,timestamps --parents "{}" $TARGET

