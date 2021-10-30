#!/usr/bin/perl

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

# http://search.cpan.org/~olaf/Net-DNS-0.68/lib/Net/DNS/Resolver.pm
use Net::DNS::Resolver;
my $resolver = Net::DNS::Resolver->new(
  #nameservers => [qw(10.5.0.1)],
);
$resolver->udp_timeout(1);

my $query = '';
my $dns = "-";
my @ip_cache = ();
my @host_cache = ();
my @output = ();

while (my $line = <>) {
	chomp($line);
	$line =~ s/\s*$//g;
	
	#my $match_ip = quotemeta "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}";
	#my @ipaddresses = split /($match_ip)/, $line;
	my @ipaddresses = split /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/, $line;
	foreach my $ip (@ipaddresses) {
		next if ($ip !~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/);
		next if (grep /^$ip$/, @ip_cache);
		push @ip_cache, $ip;

		#$query = $resolver->search($ip);
		$query = $resolver->query($ip, 'PTR');
	   $dns = "-";
		if ($query) {
			foreach my $rr ($query->answer) {
				next unless $rr->type eq "PTR";
				#$dns = $rr->address;
				#print Dumper($rr);
				$dns = $rr->ptrdname;
				last;
			}
		}
		#printf ("%-15s\tPTR\t%s\n", $ip, $dns);
		push @output, sprintf ("%-15s\tPTR\t%s\n", $ip, $dns);
	}
	#print Dumper(\@ipaddresses);

	my @hostnames = split /([\w\d\-\.]+\.[a-z]{2,8})/i, $line;
	#print Dumper(@hostnames);
	foreach my $host (@hostnames) {
		#print "-- host = '$host'\n";
		next if ($host !~ /^[\w\d\-\.]+\.[a-z]{2,8}$/i);
		next if ($host =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/);
		next if (grep /^$host$/, @host_cache);
		push @host_cache, $host;

		#$query = $resolver->search($ip);
		$query = $resolver->query($host, 'A');
	   $dns = "-";
		if ($query) {
			foreach my $rr ($query->answer) {
				next unless $rr->type eq "A";
				#$dns = $rr->address;
				#print Dumper($rr);
				$dns = $rr->address;
				last;
			}
		}
		#printf ("%-15s\tA\t%s\n", $dns, $host);
		push @output, sprintf ("%-15s\tA\t%s\n", $dns, $host);
	}
	#print Dumper(\@ipaddresses);
}

print sort @output;




