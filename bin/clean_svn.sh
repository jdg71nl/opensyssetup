#!/bin/bash

echo find . -type d -name '.svn' -exec echo 'rm -rf "{}"' \; -exec 'rm -rf "{}"' \;
find . -type d -name '.svn' -exec echo 'rm -rf "{}"' \; -exec rm -rf "{}" \;

