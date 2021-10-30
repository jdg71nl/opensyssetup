#!/usr/bin/perl
use URI::Escape;
while (my $in = <>) {
	chomp $in;
	print uri_escape($in)."\n";
}

