#!/bin/sh
cat | openssl base64 -d | tar xvzf - 

