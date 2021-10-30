#!/usr/bin/perl
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;
#%counts = {};
while (my $line=<STDIN>) {
	chomp($line);
	#print "$line\n";
	@tablist = split "\t", $line;
	my $col1 = $tablist[0] || '';
	my $col2 = $tablist[1] || '';
	my $col3 = $tablist[2] || '';
	next if $col3 !~ /^\d+$/i;
	#
	#my $string = "parsed-line: $col1 $col2 $col3"; 
	#print "$string\n";
	#
	my $switch = "$col1--$col2";
	if (exists( $counts{$switch} )) {
		$counts{$switch} = $counts{$switch} + 1;
	} else {
		$counts{$switch} = 1
	}
}
#print Dumper( %counts );
foreach my $switch (keys %counts) {
	print "$switch : $counts{$switch} \n"
}
#
