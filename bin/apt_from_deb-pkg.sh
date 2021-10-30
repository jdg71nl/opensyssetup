#!/bin/bash

LIST=`cat | perl -pe 's/\n/ /'`
CMD="apt-get install $LIST"
echo $CMD

