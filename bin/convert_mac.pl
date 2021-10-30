#!/usr/bin/perl

my $output = $ARGV[0] || die 'provide arg: dump|2to4|2toCisco|2toHP';

# Example input	output
# 2to4 00:07:5f:72:e2:d5 0007.5f72.e2d5

while (my $line=<STDIN>) {
	chomp($line);
	#print "$line\n";

	my $b1 = '';
	my $b2 = '';
	my $b3 = '';
	my $b4 = '';
	my $b5 = '';
	my $b6 = '';

	if ($line =~ /^([\w\d]+):([\w\d]+):([\w\d]+):([\w\d]+):([\w\d]+):([\w\d]+)/i) {
		$b1 = $1;
		$b2 = $2;
		$b3 = $3;
		$b4 = $4;
		$b5 = $5;
		$b6 = $6;
	}

	if ($line =~ /^([\w\d]{2})([\w\d]{2}).([\w\d]{2})([\w\d]{2}).([\w\d]{2})([\w\d]{2})/i) {
		$b1 = $1;
		$b2 = $2;
		$b3 = $3;
		$b4 = $4;
		$b5 = $5;
		$b6 = $6;
	}

	if ($output eq 'dump') {
		print "$line\n";
	}

	if ($output eq '2to4') {
		my $mac = "$1$2.$3$4.$5$6";
		$mac = lc($mac);
		print "$mac\n";
	}

	if ($output eq '2toCisco') {
		my $mac = "$1$2.$3$4.$5$6";
		$mac = lc($mac);
		print "show mac address-table address $mac\n";
	}

	if ($output eq '2toHP') {
		my $mac = "$1$2.$3$4.$5$6";
		$mac = lc($mac);
		print "show mac-address $mac\n";
	}

}

