#!/usr/bin/perl
use URI::Escape;
while (my $in = <>) {
	chomp $in;
	print uri_unescape($in)."\n";
}

