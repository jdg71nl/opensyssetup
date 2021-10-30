#!/bin/bash
SRC=$1
DST=$2
if [[ -z $DST ]]; then 
	echo "usage: $0 infile.jpg outfile.jpg"
	exit
fi

# https://gist.github.com/Ocramius/71c0557e378901e3816df77d5804c2ad
#
#convert "$SRC" -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 "$DST"

# https://stackoverflow.com/questions/23342145/imagemagick-script-giving-unexpected-result-with-a-different-coloured-images
#
#convert "$SRC" \
#        -morphology EdgeIn Octagon \
#        -negate -normalize -blur 0x2 \
#        -channel RGB -level 50%,81%,0.1 \
#        -colorspace Gray \
#        "$DST"
#
convert "$SRC" \
        -morphology Convolve DoG:15,100,0 \
        -negate -normalize -blur 0x1 \
        -channel RGB -level 50%,98%,0.1 \
        -colorspace Gray \
        "$DST"

