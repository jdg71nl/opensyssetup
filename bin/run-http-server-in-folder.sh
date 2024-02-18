#!/bin/bash

# https://ostechnix.com/how-to-quickly-serve-files-and-folders-over-http-in-linux/
#ruby -run -e httpd . -p8000

# https://apidock.com/ruby/v2_5_5/Object/httpd
ruby -run -e httpd . -p8080 --bind-address='0.0.0.0'

#-eof

