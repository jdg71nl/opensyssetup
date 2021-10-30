#!/bin/bash
find -type f -name "[0-9][0-9]*" -size +100k -exec ls -altrhp {} \; -exec /usr/local/syssetup/bin/strip_attachments.sh "{}" \;

