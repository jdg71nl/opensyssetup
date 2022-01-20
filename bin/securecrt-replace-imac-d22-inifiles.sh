#!/bin/bash
#
find . -type f -iname '*.ini' -print -exec perl -pi -e "s/S:\"Log Filename V2\"=.*$/S:\"Log Filename V2\"=\/Volumes\/Jdg1TssT7touch\/Jdg1TssT7touch\/Dropbox\/Cloud\/SecureCRT-logs\/d22%M%D-%h%m--%H--%S--session.log/" "{}" \;
#
#-EOF

