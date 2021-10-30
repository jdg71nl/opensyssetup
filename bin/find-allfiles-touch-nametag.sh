#!/bin/bash

echo find . -type f -exec touch-nametag.sh "{}" \;
find . -type f -exec touch-nametag.sh "{}" \;

