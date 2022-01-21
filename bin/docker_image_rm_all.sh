#!/bin/bash
docker image rm -f $(docker image ls -q)
#-EOF
