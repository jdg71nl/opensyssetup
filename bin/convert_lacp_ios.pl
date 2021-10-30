#!/usr/bin/perl

# Example input from XLS (with tabs between cells):
# Po	po-descr	member1	member2	member3	member4
# 1	SW-DB-CORE1	gi1/0/47	gi3/0/47		
# 3	FS-01	gi3/0/5	gi2/0/5	gi1/0/5	gi2/0/6

while (my $line=<STDIN>) {
	chomp($line);
	#print "$line\n";
	#$line =~ /^([\S]+)\s+([\S]+)\s+([\S]+)\s+([^\t]+)\s+([\S]+)\s+([\S]+).*$/i;
	@tablist = split "\t", $line;
	my $po	 	= $tablist[0] || '';
	my $descr	= $tablist[1] || '';
	my $member1	= $tablist[2] || '';
	my $member2	= $tablist[3] || '';
	my $member3	= $tablist[4] || '';
	my $member4	= $tablist[5] || '';
	next if $po !~ /^\d+$/i;
	my $string = "LACP-po$po-$descr"; 
	my @members = ($member1, $member2);
	push @members, $member3 if $member3;
	push @members, $member4 if $member4;
	foreach my $m (@members) {
		print "interface $m\n";
		print " description $string\n";
		print " channel-group $po mode active\n";
		print " channel-protocol lacp\n";
		print "!\n";
	}
	print "interface po $po\n";
	print " description $string\n";
	print "!\n";
}

