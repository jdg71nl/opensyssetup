#!/bin/bash
for file in ~/.unison/ar*; do
	echo -e "--\nfile: $file"; head -n 3 $file | strings | perl -pe 's/(roots |, )(\/\/)/$1\n$2/g'; 
done
echo "--"

# show_unison_archive_files.sh | grep 'syssetup,' | perl -pe 's/^\/\/(.*?)\/\/.*$/$1/' | sort | uniq
# show_unison_archive_files.sh | egrep '^//' | perl -pe 's/^\/\/(.*?)\/\/.*$/$1/' | sort | uniq

