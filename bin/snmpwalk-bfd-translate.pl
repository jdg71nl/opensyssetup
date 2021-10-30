#!/usr/bin/perl -w
# snmpwalk-bfd-translate.pl
# debian: 
# aptitude install libnet-snmp-perl libnetaddr-ip-perl

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use strict;
use warnings;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;
use Getopt::Long;
use File::Basename ;
use Cwd 'abs_path'; # also resolves symlinks
use Net::SNMP;
use NetAddr::IP;

my $nr_args = @ARGV;
my $allopts = join " ", @ARGV;
my %options = ();
GetOptions(\%options, 'c=s', 'ip=s', 'h|help');
#print Dumper(\%options);

my $basename = basename(abs_path($0)) ; # only name, abs_path resolves symlinks
my $basedir = dirname(abs_path($0)); # without trailing slash
#print "$basename $allopts\n";

sub help {
        my $msg = shift || '';
        print "$msg\n" if $msg;
        print "\n";
        print "Usage: $basename --c community-string --ip ip-address\n";
        print "\n";
        exit 0;
}
help() if (exists $options{h} or exists $options{help});
help() if $nr_args < 1;
help("Error: no community-string provided") if not exists $options{c};
help("Error: no IP address provided") if not exists $options{ip};

my ($session, $error) = Net::SNMP->session(
        -hostname      => $options{ip},
        -port          => 161,
        -timeout       => 2,
        -retries       => 2,
        -community     => $options{c},
);

if (!defined $session) {
        printf "ERROR: connection failed\n", $error;
        exit 1;
}

my $OID_string__bfdSessState = ".iso.org.dod.internet.private.enterprises.juniperMIB.jnxExperiment.jnxBfdExperiment.bfdMIB.bfdObjects.bfdSessTable.bfdSessEntry.bfdSessState";
my $OID_numeric_bfdSessState = ".1.3.6.1.4.1.2636.5.3.1.1.2.1.6";
my $OID_syntax__bfdSessState = "INTEGER {adminDown(1), down(2), init(3), up(4) }";

my $OID_string__bfdSessAddr = ".iso.org.dod.internet.private.enterprises.juniperMIB.jnxExperiment.jnxBfdExperiment.bfdMIB.bfdObjects.bfdSessTable.bfdSessEntry.bfdSessAddr";
my $OID_numeric_bfdSessAddr = ".1.3.6.1.4.1.2636.5.3.1.1.2.1.14";
my $OID_syntax__bfdSessAddr = "InetAddress";

my $oid = $OID_numeric_bfdSessAddr;
my $result = $session->get_table(-baseoid => $oid);

if (!defined($result)) {
  printf "ERROR: %s.\n", $session->error();
  $session->close();
  exit 1;
}

$session->close();

sub hex2ip { return join(".", map {hex($_)} unpack('A2 A2 A2 A2',shift )) }

print "\n";
print "# IP-adresses from the BFD Session table, which will show you the session-nr:\n";
print "OID_string__bfdSessAddr = $OID_string__bfdSessAddr\n";
print "OID_numeric_bfdSessAddr = $OID_numeric_bfdSessAddr\n";
print "\n";
print "# use the isession-nr appended to the bfdSessState OID to read the state:\n";
print "OID_string__bfdSessState = $OID_string__bfdSessState\n";
print "OID_numeric_bfdSessState = $OID_numeric_bfdSessState\n";
print "\n";

#print Dumper(\$result);

foreach my $key (sort keys %$result) {
        my $hexstring = $result->{$key} ;  # 0x0a04fd05
        #$hexstring =~ s/0x(\w\w)(\w\w)(\w\w)(\w\w)/$1.$2.$3.$4/;
        #my $ip = hexip( $hexstring );
        $hexstring =~ s/0x//;
        my $ip = hex2ip( $hexstring );
        printf "%s => %s\n", $key, $ip;
}
print "\n";

foreach my $key (sort keys %$result) {
        my $hexstring = $result->{$key} ;  # 0x0a04fd05
        $hexstring =~ s/0x//;
        my $ip = hex2ip( $hexstring );
        my $state = $key;
        $state =~ s/$OID_numeric_bfdSessAddr/$OID_numeric_bfdSessState/;
        printf "%s => BFD.state(peer:%s)\n", $state, $ip;
}
print "\n";

exit 0;
