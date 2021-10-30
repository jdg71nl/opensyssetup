#!/bin/sh
#cat | grep -v '^[[:space:]]*$' | grep -v '^#.*$'
cat | grep -v '^[[:space:]]*$' | grep -v '^\s*#'
#
