#!/usr/bin/perl

# usage:
# cat /tmp/x  | ./ip-calc-first.pl | xargs -i echo "ping {}"
# cat /tmp/x  | ./ip-calc-first.pl | xargs -i echo "ping {}" | sort-ipv4.sh | uniq 


# centos: yum install perl-NetAddr-IP
use NetAddr::IP;

while (my $subnet=<>) {
	chomp $ubnet;
	my $naip = NetAddr::IP->new($subnet);
	next if not $naip;
	print $naip->first()->addr()."\n";
}

