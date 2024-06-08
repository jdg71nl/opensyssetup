#!/bin/bash

#ssh jdg@10.86.91.254
#ssh -X jdg@10.86.91.254

# $* is a single string, whereas $@ is an actual array.
ssh jdg@10.86.91.254 $@

#-eof

