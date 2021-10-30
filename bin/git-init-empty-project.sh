#!/bin/bash
#
if [[ ! -d .git/ ]]; then
	git init
	mkdir project
	touch project/info.txt
	git add project/info.txt 
	git commit -m "initial"
else
	echo "# git repo already exists! [exit 1]"
	exit 1
fi

#-EOF

