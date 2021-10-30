#!/usr/bin/perl
my $ip = shift @ARGV || 0;
while (my $line=<STDIN>) {
	chomp $line;
	$line =~ /v(\d+)([-_][\w\d-]+)/ ;
	my $vlan  = $1 || 0;
	my $d = $2 || '';
	my $descr = "v${vlan}${d}";
	if ($vlan == 0) {
		print "$line\n";
	} else {
		if ($ip) { 
			print "set vlan v$vlan vlan-id $vlan l3-interface vlan.$vlan description $descr\n";
		} else {
			print "set vlan v$vlan vlan-id $vlan description $descr\n";
		}
	}
}

