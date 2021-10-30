#!/bin/sh

TAR=$1
if [[ -z "$TAR" ]]; then
        echo "provide tar file"
        exit 1
fi

BIN=`tar tvf $TAR | grep bin | perl -pe 's/^.*?\/(.*)\.bin$/$1/'`
if [[ -z "$BIN" ]]; then
        echo "no BIN file in tar found"
        exit 1
fi

tar xvf $TAR $BIN/$BIN.bin
mv $BIN/$BIN.bin .
rmdir $BIN
touch $BIN.bin

