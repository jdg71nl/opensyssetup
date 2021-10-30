#!/bin/bash
find -type f -empty -printf "%021T@ [%32Tc] (%10s Bytes) %p\n" -exec rm "{}" \;

