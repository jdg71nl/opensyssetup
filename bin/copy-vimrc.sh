#!/bin/bash
SOURCE="$HOME/opensyssetup/debian/root/dot.vimrc"
TARGET="$HOME/.vimrc"
[ -f $TARGET ] && cp -av $TARGET $TARGET.back
cp -v $SOURCE $TARGET
#-eof
