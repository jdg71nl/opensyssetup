#!/bin/bash
cat zones/named-masterslavelist.txt  | perl -ne '$s=$_;chomp($s);$s=~s/^.*?\.([^\.]+)$/$1/;print"$s\n";' | sort | uniq

