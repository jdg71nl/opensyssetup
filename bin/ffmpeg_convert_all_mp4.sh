#!/bin/bash
#= ffmpeg_convert_all_mp4.sh
#
# on Mac: brew install ffmpeg
# need '-pix_fmt yuv420p' to get MP4 that play on Mac
#
for x in *.AVI ; do echo $x ; ffmpeg -i $x -pix_fmt yuv420p $x.mp4 ; done
#
