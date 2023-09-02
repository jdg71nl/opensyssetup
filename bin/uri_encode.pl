#!/usr/bin/perl
# also info here: https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
use URI::Escape;
while (my $in = <>) {
	chomp $in;
	print uri_escape($in)."\n";
}

