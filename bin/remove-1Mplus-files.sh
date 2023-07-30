#!/bin/bash

echo find . -type f -size +1024k  -printf "%010T@ [%Tc] (%10s Bytes) %p\n" -exec rm "{}" \;
find . -type f -size +1024k  -printf "%010T@ [%Tc] (%10s Bytes) %p\n" -exec rm "{}" \;

