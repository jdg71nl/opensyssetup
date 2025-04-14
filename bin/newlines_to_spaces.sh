#!/bin/bash
# https://unix.stackexchange.com/questions/593993/convert-multi-lines-to-single-line-with-spaces-and-quotes
cat | sed 's/.*/&/' | paste -sd' ' -
#-eof
