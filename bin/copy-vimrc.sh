#!/bin/bash
SOURCE="/usr/local/syssetup/debian/root/dot.vimrc"
TARGET="$HOME/.vimrc"
[ -f $TARGET ] && cp -a $TARGET $TARGET.back
cp $SOURCE $TARGET

