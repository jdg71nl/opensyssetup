#!/bin/bash

fif () 
{ 
	    echo "# bash-function 'fif':";
		     /usr/bin/find . -xtype f -iname '*'$2'*' -print0 | xargs -0i grep -sinH "$1" "{}"
}

fif chassis | egrep -i 'srx100.?$'


