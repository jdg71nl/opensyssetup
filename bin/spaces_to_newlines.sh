#!/bin/bash
# https://stackoverflow.com/questions/57045502/bash-split-a-single-line-of-output-with-spaces-into-multiple-lines-of-one-word
cat | tr -s '[:blank:]' '\n'
#-eof
