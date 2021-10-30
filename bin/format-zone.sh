#!/bin/sh
cat | egrep -v "^;|^\s*$" | perl -pe "s/\s+/\t/"
