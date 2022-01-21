#!/bin/bash
FILE="~/.Xauthority" if [ -f ${FILE} ]; then STAMP=$( date +%y%m%d-%H%M%S ) ; mv -v ${FILE} ${FILE}.b${STAMP} ; fi
echo "disabled" > ~/.Xauthority 
#
