#!/bin/bash
PAT=$*
if [[ -z $PAT ]]; then 
	PAT='*'
fi
for file in $PAT ; do echo -e "\n# ---------+++--------- ---------+++--------- ---------+++--------- ---------+++--------- \n# cmd> cat $file \n" ; cat $file ; echo ; done

