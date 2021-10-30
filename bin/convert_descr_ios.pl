#!/usr/bin/perl

# Example input from XLS (with tabs between cells):
# Port	Descr
# gi1/0/3	s04 1

while (my $line=<STDIN>) {
	chomp($line);
	#print "$line\n";
	#$line =~ /^([\S]+)\s+([\S]+)\s+([\S]+)\s+([^\t]+)\s+([\S]+)\s+([\S]+).*$/i;
	@tablist = split "\t", $line;
	my $port  = $tablist[0] || '';
	next if $port !~ /^(gi|fa|te)/i;
	my $descr = $tablist[1] || '';
	next if $descr =~ /^\s*$/;
	print "interface $port\n";
	print " description $descr\n";
	print "!\n";
}

