#!/bin/sh
FILE=$1
ffmpeg -ss 0 -vframes 1 -i $FILE $FILE.png

