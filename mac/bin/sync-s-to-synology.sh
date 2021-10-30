#!/bin/sh

echo "provide admin pwd on synology:"
rsync -rtv --exclude='.*' /Volumes/JDG-SMAC/SMAC/ rsync://admin@10.77.64.10/system-s/s/JDG-SMAC/SMAC/


