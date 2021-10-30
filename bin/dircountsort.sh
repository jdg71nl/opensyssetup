#!/bin/bash

find . -type d -print | perl -ne 'while ($_) {$d=$_;chomp($d); opendir($dh,"$d");$i=0;while(readdir $dh){$i++};printf "%8d\t%s\n", $i,$d;}' | sort -n


