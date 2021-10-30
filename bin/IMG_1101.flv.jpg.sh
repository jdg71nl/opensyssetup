#!/bin/bash
# extract first from of video as a image:
ffmpeg -i IMG_1101.flv -ss 0 -vframes 1 IMG_1101.flv.jpg

