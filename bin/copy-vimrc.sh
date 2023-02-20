#!/bin/bash
SOURCE="$HOME/opensyssetup/debian/root/dot.vimrc"
TARGET="$HOME/.vimrc"
[ -f $TARGET ] && cp -a $TARGET $TARGET.back
cp $SOURCE $TARGET

