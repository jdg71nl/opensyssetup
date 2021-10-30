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
use NetAddr::IP;
#use Template;

#####################################################################
my $nr_args = @ARGV;
my $allopts = join " ", @ARGV;
my %options = ();
GetOptions(\%options, 'dev=s', 'ip=s', 'gw=s', 'ns=s', 'route=s@', 'h|help');
#print Dumper(\%options);

#####################################################################
my $basename = basename(abs_path($0)) ; # only name, abs_path resolves symlinks
system "logger \"$basename started as [$0 $allopts]\"";
my $basedir = dirname(abs_path($0)); # without trailing slash

print "$basename $allopts\n";
print "\n";
#####################################################################
sub help {
	my $msg = shift || '';
	print "$msg\n" if $msg;
	print "\n";
	print "Usage: $basename -dev device --ip ip/mask --gw gw --ns ns --route ip/mask=dest --route ip/mask=dest\n";
	print "\n";
	print "Examples:\n";
	print "$basename --dev eth0 --ip 172.24.1.10/24 --gw .254\n";
	print "$basename --dev eth0 --route 192.168.100.0/24=172.24.1.240\n";
	print "\n";
	print "Note: GW/NS/Routes can be abbreviated to the last bytes.\n";
	print "      They will automatically be expaned to the given IP network.\n";
	print "\n";
	exit 0;
}

#####################################################################
help() if (exists $options{h} or exists $options{help});
help() if $nr_args < 1;

#system "find /etc/sysconfig/networking/ -type f -name 'ifcfg-*' "

#####################################################################
my $ifcfg_file = "/etc/sysconfig/network-scripts/ifcfg-$options{dev}";
help("unknown device '$options{dev}' (file '$ifcfg_file' does not exist..)") if not -f $ifcfg_file;

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
);
#print Dumper(\%ip);

my $dhcp_format = <<HERE;

DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
TYPE=Ethernet
PEERDNS=yes

HERE

#####################################################################
# GW 
# can be shorthand '.254' -- expand

sub merge_ip {
	my $adr = shift;
	my $gw = shift || '';
	my @address_array = split /\./, $adr;
	my @shortgw_array = split /\./, $gw;
	@shortgw_array = grep {!/^$/} @shortgw_array;
#print "address_array=".Dumper(@address_array)."\n";
#print "shortgw_array=".Dumper(@shortgw_array)."\n";
	my @gw_array = @address_array;
	if (@shortgw_array == 1) { pop @gw_array;											push @gw_array, $shortgw_array[0]; }
	if (@shortgw_array == 2) { pop @gw_array; pop @gw_array;						push @gw_array, @shortgw_array[0,1]; }
	if (@shortgw_array == 3) { pop @gw_array; pop @gw_array; pop @gw_array;	push @gw_array, @shortgw_array[0,1,2]; }
	if (@shortgw_array == 4) { @gw_array = @shortgw_array; }
	return join ".", @gw_array;
}

my $gw = "";
if (exists $options{gw}) {
	$gw = merge_ip($ip{ADDRESS}, $options{gw});
	#print "gw=$gw\n";
	my $nagw = NetAddr::IP->new($gw);
	die "invalid GW address '$gw'" if not $nagw;
	die "GW address '$gw' not within IP subnet of $options{dev}" if not $nagw->within($naip);
}

#####################################################################
# NS

my $ns = "";
if (exists $options{ns}) {
	$ns = merge_ip($ip{ADDRESS}, $options{ns});
	#print "gw=$gw\n";
	my $nans = NetAddr::IP->new($ns);
	die "invalid NS address '$ns'" if not $nans;
	$ns = $nans->addr();
}

#####################################################################
# Routes

my %routes = ();
my @route_lines = ();
my $i = 0;
for my $route (@{$options{route}}) {
	my ($dest, $nexthop) = split /=/, $route;
	my $na_dest = NetAddr::IP->new($dest);
	die "Invalid destination '$dest' in route" if not $na_dest;
	my $nh = merge_ip($ip{ADDRESS}, $nexthop);
	my $na_nh = NetAddr::IP->new($nh);
	die "Invalid nexthop '$nh' in route" if not $na_nh;
	die "Nexthop address '$nh' not within IP subnet of $options{dev}" if not $na_nh->within($naip);

	$routes{$na_dest->cidr()} = $na_nh->addr();
	push @route_lines, "ADDRESS$i=".$na_dest->addr();
	push @route_lines, "NETMASK$i=".$na_dest->mask();
	push @route_lines, "GATEWAY$i=".$na_nh->addr();
	$i++;
}

unshift @route_lines, "# Created by $basename on ".localtime(time);
#print "routes:" . Dumper(\%routes)."\n";

#####################################################################
open FH, $ifcfg_file;
my @ifcfg_lines = <FH>;
close FH;
@ifcfg_lines = map {chomp; $_} @ifcfg_lines;
@ifcfg_lines = grep {!/appended|IPADDR|NETMASK|NETWORK|BROADCAST|GATEWAY/} @ifcfg_lines;

my $route_file = "/etc/sysconfig/network-scripts/$options{dev}.route";
#my @route_list = map { /^(ADDRESS|NETMASK|GATEWAY)(\d+)=(.*)$/; $2 => {$1 => $3}  } @route_lines;

my $resolv_file = "/etc/resolv.conf";
die "file '$resolv_file' not readable" if not -f $resolv_file;
open FH, $resolv_file;
my @resolv_lines = <FH>;
close FH;
@resolv_lines = map {chomp; $_} @resolv_lines;
@resolv_lines = grep {!/nameserver/i} @resolv_lines;

#print Dumper(\@ifcfg_lines)."\n";
#print Dumper(\%route_hash)."\n";

push @ifcfg_lines, "# appended by $basename on ".localtime(time).":";
push @ifcfg_lines, "IPADDR=".$ip{ADDRESS};
push @ifcfg_lines, "NETMASK=".$ip{MASK};
push @ifcfg_lines, "NETWORK=".$ip{NETWORK};
push @ifcfg_lines, "BROADCAST=".$ip{BROADCAST};
if ($gw) {
	push @ifcfg_lines, "GATEWAY=".$gw;
}

if ($ns) {
	push @resolv_lines, "nameserver $ns" ;
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time()) ;
my $shortyear = ($year - 100) % 100;
my $timetag = sprintf("d%02d%02d%02d-%02d%02d%02d", $shortyear, $mon+1, $mday, $hour, $min, $sec);
#print "timetage=$timetag\n";

sub backup_f {
	my $f = shift;
	my $b = "/tmp/".basename($f).".backup.$timetag";
	system "cp $f $b";
	print "file '$f' is backup as '$b'\n";
}
backup_f($ifcfg_file);
backup_f($route_file) if -f $route_file;
backup_f($resolv_file) if $ns;

print "\n";
print "$ifcfg_file:\n";
print join "\n", @ifcfg_lines;
print "\n";
print "\n";

open FH, ">$ifcfg_file";
print FH join "\n", @ifcfg_lines;
print FH "\n";
close FH;

if (%routes) {
	print "\n";
	print "$route_file:\n";
	print join "\n", @route_lines;
	print "\n";
	print "\n";

	open FH, ">$route_file";
	print FH join "\n", @route_lines;
	print FH "\n";
	close FH;
} else {
	unlink $route_file if -f $route_file;
}

if ($ns) {
	print "\n";
	print "$resolv_file:\n";
	print join "\n", @resolv_lines;
	print "\n";
	print "\n";

	open FH, ">$resolv_file";
	print FH join "\n", @resolv_lines;
	print FH "\n";
	close FH;
}



#####################################################################
__DATA__

DEVICE=eth0
BOOTPROTO=static
BROADCAST=10.0.0.255
#HWADDR=00:40:F4:8A:23:2F
IPADDR=10.0.0.9
NETMASK=255.255.255.0
NETWORK=10.0.0.0
ONBOOT=yes
TYPE=Ethernet


#push @addresses, NetAddr::IP->new($_) for <DATA>;
#print join(", ", NetAddr::IP::compact(@addresses)), "\n";
__DATA__
10.0.0.0/18
10.0.64.0/18
10.0.192.0/18
10.0.160.0/19

