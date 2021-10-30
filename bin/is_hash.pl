#!/usr/bin/perl
my $p=shift || '';
chomp $p;
my $h = ($p =~ /^\$\d\$[a-zA-Z0-9.\/]+\$[a-zA-Z0-9.\/]+$/ ? 1:0);
print "$h\n";

