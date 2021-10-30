#!/bin/sh

# name of link-tree directory:
LDIR="$HOME/Pictures/links-iPhoto-MacBook-jdg"

# create/clean link-tree directory:
mkdir -pv "$LDIR"
rm -rf $LDIR/*

# create links to all ORI photos:
cd $HOME/Pictures/iPhoto\ Library/Originals/ 
echo "--- mkdir..."
find . -type d -print -exec mkdir -pv "$LDIR/{}" \;
echo
echo "--- linking originals..."
find . -type f -print -exec ln -v "{}" "$LDIR/{}" \;
echo

# replace links with MOD photos (if they exist):
cd $HOME/Pictures/iPhoto\ Library/Modified/ 
echo "--- linking modifieds..."
find . -type f -exec ln -vf "{}" "$LDIR/{}" \;
echo

