#!/bin/bash
echo "# cmd> curl -v -s -o - -X OPTIONS -H \"Custom-Test-Header: So this is a test header.\" $1"
curl -v -s -o - -X OPTIONS -H "Custom-Test-Header: So this is a test header." $1

