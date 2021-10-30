#!/usr/bin/perl

# Example input from XLS (with tabs between cells):
# switchname	IP
# F101N01010-SW01	172.17.18.130
# F101N01010-SW02	172.17.18.131

print "'devices' => {\n";

while (my $line=<STDIN>) {
	chomp($line);
	@tablist = split "\t", $line;
	my $switchname	= $tablist[0] || '';
	my $ip		= $tablist[1] || '';
	next if $switchname =~ /switchname/i;
	next if $ip eq '';
	print "'$switchname' => {\n";
	print " 'ip' => '$ip',\n";
	print "},\n";
}

print "}\n";

