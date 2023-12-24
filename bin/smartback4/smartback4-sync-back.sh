#!/bin/bash 
#= smartback4-sync-back.sh 

DIR="$1"

mkdir -pv /var/local/backup/smartback4/$DIR/ 
rsync -v -rtlz -e "ssh -p 48722" smartback4@185.84.140.52:smartback4/$DIR/ /var/local/backup/smartback4/$DIR/ 

#-eof

