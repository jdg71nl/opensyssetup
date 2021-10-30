#!/usr/bin/perl

use strict;
use warnings;

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use Getopt::Long;
use File::Basename ;
use Cwd 'abs_path'; # also resolves symlinks
#use Cwd 'getcwd';
use Data::Dumper;

# centos: yum install perl-NetAddr-IP
# debian: aptitude install netaddr
use NetAddr::IP;

#use Template;

#####################################################################
my $nr_args = @ARGV;
my $allopts = join " ", @ARGV;
my %options = ();
GetOptions(\%options, 'ip=s', 'h|help');
#print Dumper(\%options);

#####################################################################
my $basename = basename(abs_path($0)) ; # only name, abs_path resolves symlinks
my $basedir = dirname(abs_path($0)); # without trailing slash

#print "$basename $allopts\n";
#print "\n";

#####################################################################
sub help {
	my $msg = shift || '';
	print "$msg\n" if $msg;
	print "\n";
	print "Usage: $basename --ip ip/mask\n";
	print "\n";
	print "Will show you: network, broadcast, mask, etc of the supplied IP-subnet\n";
	print "\n";
	exit 0;
}

#####################################################################
help() if (exists $options{h} or exists $options{help});
help() if $nr_args < 1;

#####################################################################
help("no IP address given") if not exists $options{ip};
my $naip = NetAddr::IP->new($options{ip});
#print STDERR "calling NetAddr::IP->new($ipa)\n";
help("invalid IP address '$options{ip}'") if not $naip;

my %ip = (
	ADDRESS		=> $naip->addr(),
	NETWORK		=> $naip->network()->addr(),
	BROADCAST 	=> $naip->broadcast()->addr(),
	MASK			=> $naip->mask(),
	BITS			=> $naip->masklen(),
	CIDR			=> $naip->cidr(),
	RANGE			=> $naip->range(),
	NUM			=> $naip->num(),
	FIRST			=> $naip->first()->addr(),
	LAST			=> $naip->last()->addr(),
);

#print Dumper(\%ip);

print <<HERE
IP address               : $ip{ADDRESS}
CIDR                     : $ip{CIDR}
Mask size                : $ip{BITS}
Netmask                  : $ip{MASK}
Subnet range             : $ip{RANGE}
Network address          : $ip{NETWORK}
First usable address     : $ip{FIRST}
Last usable address      : $ip{LAST}
Broadcast address        : $ip{BROADCAST}
Number of usable address : $ip{NUM}
HERE

