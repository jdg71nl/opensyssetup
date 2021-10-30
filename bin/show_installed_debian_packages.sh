#!/bin/bash
dpkg -l | egrep '^ii' | awk '{print $2};'

