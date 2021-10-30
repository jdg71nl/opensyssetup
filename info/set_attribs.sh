#!/bin/sh
find -type f -exec chmod 644 "{}" \;
find -type f -iname '*.sh' -exec chmod +x "{}" \;
find -type f -iname '*.pl' -exec chmod +x "{}" \;

