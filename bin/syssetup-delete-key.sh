#!/bin/bash
KEY=$1

echo ssh syssetup@syssetup.networkconcepts.nl "rm -v .unison/$KEY"
ssh syssetup@syssetup.networkconcepts.nl "rm -v .unison/$KEY"

