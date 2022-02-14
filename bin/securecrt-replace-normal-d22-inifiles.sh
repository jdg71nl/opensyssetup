#!/bin/bash
#
find . -type f -iname '*.ini' -print -exec perl -pi -e "s/S:\"Log Filename V2\"=.*$/S:\"Log Filename V2\"=\/Users\/jdg\/Dropbox\/Cloud\/SecureCRT-logs\/d22%M%D-%h%m--%H--%S--session.log/" "{}" \;
#
#-EOF

