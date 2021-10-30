#!/bin/bash

find . -xtype f -iname '[1-9]*' -print0 | xargs -0i egrep -sinH "host-?name" "{}"

echo

