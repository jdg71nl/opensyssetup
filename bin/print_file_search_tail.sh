#!/bin/bash

usage() {
	echo "Usage: `basename $0` <filename> <pattern> <lines>"
	echo "  Will do: cat \"\$file\" | grep -i "$pattern" | tail -n \$lines"
	exit 1
}

errorusage() { echo "$1"; usage;}
error() { echo "$1"; exit 1;}

[[ $# -eq 3 ]] || usage

file="$1"
pattern="$2"
lines="$3"

[[ -f "$file" ]] || [[ -d "$file" ]] || errorusage "Error: '$file' not a regular file or directory!"
[[ $lines =~ ^[1-9][0-9]*$ ]]        || errorusage "Error: '$lines' not a number greater than 0!"

if [[ -f "$file" ]]; then
	if [[ -z "$pattern" ]]; then
		tail -n $lines "$file" | strings
	else
		cat "$file" | grep -i "$pattern" | tail -n $lines
	fi
else
	if [[ -d "$file" ]]; then
		egrep -asinHT -m $lines "$pattern" $file | strings | tail -n $lines
	else 
		errorusage "Error: unknown file-type"
	fi
fi

exit 0

