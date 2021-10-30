#!/usr/bin/perl -w

use strict;
use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use Sys::Syslog ;
use Net::SNMP;
use Net::Ping;
use Time::HiRes ;
use Getopt::Std;
use POSIX qw(strftime);
use RRDs;
use IO::Socket ;
use File::Basename ;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;
				
my $sysDescr                            = '1.3.6.1.2.1.1.1';
my $ifDescr                             = '1.3.6.1.2.1.2.2.1.2';
my $ifPhysAddress                       = '1.3.6.1.2.1.2.2.1.6';
my $ifOperStatus                        = '1.3.6.1.2.1.2.2.1.8';
my $ifInOctets                          = '1.3.6.1.2.1.2.2.1.10';
my $ifOutOctets                         = '1.3.6.1.2.1.2.2.1.16';
my $dot1dStpPortState                   = '1.3.6.1.2.1.17.2.15.1.3' ;
my $dot1dStpPortPathCost                = '1.3.6.1.2.1.17.2.15.1.5';
my $dot1dStpPortDesignatedBridge        = '1.3.6.1.2.1.17.2.15.1.8';
my $dot1dStpDesignatedRoot              = '1.3.6.1.2.1.17.2.5';

my $list = {
sysDescr                            => '1.3.6.1.2.1.1.1',
ifDescr                             => '1.3.6.1.2.1.2.2.1.2',
ifPhysAddress                       => '1.3.6.1.2.1.2.2.1.6',
ifOperStatus                        => '1.3.6.1.2.1.2.2.1.8',
ifInOctets                          => '1.3.6.1.2.1.2.2.1.10',
ifOutOctets                         => '1.3.6.1.2.1.2.2.1.16',
dot1dStpPortState                   => '1.3.6.1.2.1.17.2.15.1.3' ,
dot1dStpPortPathCost                => '1.3.6.1.2.1.17.2.15.1.5',
dot1dStpPortDesignatedBridge        => '1.3.6.1.2.1.17.2.15.1.8',
dot1dStpDesignatedRoot              => '1.3.6.1.2.1.17.2.5',
};

foreach my $name (sort keys %{$list} ) {
	my $oid = $list->{$name};
	my $short = qx"snmptranslate $oid";
	chomp $short;
	my $full = qx"snmptranslate -O f $oid";
	chomp $full;
	printf "%-24s %-74s %s\n", $oid, $full, $short;
}

