#!/bin/bash

echo find . -type d -exec touch-dir-nametag.sh "{}" \;
find . -type d -exec touch-dir-nametag.sh "{}" \;

