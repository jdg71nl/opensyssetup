#!/bin/bash
cat /etc/named.conf | /usr/bin/perl -ne 'if ($_=~/^\s*zone\s*"([^"]+)"\s*(.*?master.*?)\s+("[^"]+")\s*(.*)$/) {print "$1\n";}' | sort

