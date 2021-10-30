#!/usr/bin/perl

use strict;
use warnings;

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use Data::Dumper;

my $file = "";
my $inlines = "";
if ($file = $ARGV[1]) {
	open FILE, "<$file";
	$inlines = join("\n", @_=<FILE>);
	close FILE;
} else {
	while (<>) {
		$inlines .= $_;
	}
}

#my $config = do $inlines or die "Failed to interpret stdin: $! $@";
my $config = eval $inlines ; 
warn $@ if $@;

#print Dumper($config);
sub print_php;
print_php($config);
print "\n";
exit;

sub print_php {
	my $var = shift;
	if (ref($var) eq 'HASH') {
		print "array(";
		foreach my $key (sort keys %$var) {
			my $value = $$var{$key};
			print "'$key' => ";
			print_php($value);
			print ",\n";
		}
		print ")";
	} elsif (ref($var) eq 'ARRAY') {
		print "array(";
		my $nr = 0;
		foreach my $value (@$var) {
			print "'$nr' => ";
			print_php($value);
			print ",\n";
			$nr++;
		}
		print ")";
	} else {
		print "'$var'";
	}
}

