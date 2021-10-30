#!/usr/bin/perl -w

use strict;
use warnings;

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use Data::Dumper;

my $allopts = join " ", @ARGV;
help() if $allopts =~ /(-h)/;

my $showremarks = 0;
$showremarks = 1 if ($allopts =~ s/-r//);

$allopts =~ /(\S+)/;
my $address = $1 || help();

sub help {
	my $msg = shift || '';
	print "$msg\n" if $msg;
	print "-- Usage: $0 <email-address> [-r]\n";
	print "-- Will show a list of aliases that is resolved by postfix (current configuration in main.cf)\n";
	print "-- [-r] will output remarks on translation\n";
	exit 0;
}

# get postfix variables:
my $myhostname = qx"/usr/sbin/postconf -h myhostname";
chomp($myhostname);
my $mydomain = qx"/usr/sbin/postconf -h mydomain";
chomp($mydomain);
my $mydestination = qx"/usr/sbin/postconf -h mydestination";
chomp($mydestination);
$mydestination =~ s/\$myhostname/$myhostname/g;
$mydestination =~ s/\$mydomain/$mydomain/g;
my @mydestination_list = split(/\s*,\s*/, $mydestination);
my %hashTemp = map { $_ => 1 } @mydestination_list;
my @mydestinations = sort keys %hashTemp;
#print "mydestinations = " . Dumper(\@mydestinations); exit;

# get VAM (virtual_alias_maps) from current postfix config:
my $vams_string = qx"/usr/sbin/postconf -h virtual_alias_maps";
chomp($vams_string);
help "error: cannot resolve, no 'virtual_alias_maps' defined in main.cf !" if (not $vams_string) or ($vams_string =~ /\$/) ;
my @vams = split(/\s*,\s*/, $vams_string);

my @aliases = ();
my @remarks = ();

sub lookup_string {
	my $adr = shift || die;
	my $alias_string = "";
	foreach my $vam (@vams) {
		$alias_string = qx"/usr/sbin/postmap -q $adr $vam";
		chomp($alias_string);
		if ($alias_string) { # if non-empty
			last;
		}
	}
	return $alias_string;
}

sub mydestination_lookup_string {
	my $adr = shift || die;
	my $alias_string = "";

	# linear find domain from mydest-list (not finished):
	#
	#foreach my $dest (@mydestinations) {
	#	if ($adr =~ /^(.*?)@($dest)$/) {
	#		my $username = $1 || '';
	#		#$alias_string = lookup_string($);
	#	} else {
	#	}
	#}

	# search domain from email-adr in mydest-list:
	$adr =~ /^(.*?)@(.*)$/;
	my $username = $1 || return;
	my $userdomain = $2 || return;
	if (grep(/^$userdomain$/, @mydestinations)) {
		$alias_string = lookup_string($username);
		if ($alias_string) {
			push @remarks, "[alias '$adr' was not found, but alias '$username' found, with '$userdomain' in postfix:main.cf:mydestinations]";
		}
	}
	return $alias_string;
}

sub expand_alias_recursive {
	my $adr = shift;
	my $aliases_ref = shift;
	my $count = shift || die;
	#print "count=$count\n";
	if ($count > 20) {
		return ; # return after loop
	}
	my $lus = lookup_string($adr);
	#print "expand_alias_recursive(count=$count): lus=$lus\n";
	if (not $lus) {
		$lus = mydestination_lookup_string($adr);
		if  (not $lus) {
			push @remarks, "[alias '$adr' was NOT found in local alias-tables: remote delivery]";
			push @{$aliases_ref}, "remote delivery: $adr";
			return ; # return when alias was not find in any VAM
		}
	}
	if ($lus eq $adr) {
		push @remarks, "[alias '$adr' was found in local alias-tables: local delivery]";
		push @{$aliases_ref}, "local delivery: $adr";
		return ; # return when alias is same as address
	}
	# we have found an alias to another address or to multiple addresses
	my @lus_aliases = split(/\s*,\s*/, $lus);
	#print "expand_alias_recursive(count=$count): ". Dumper(\@lus_aliases);
	if (@lus_aliases == 1 ) {
		push @remarks, "[alias '$adr' is translated to: $lus ]";
	} else {
		push @remarks, "[alias '$adr' is translated to multiple aliases: ]";
		push @remarks, "[ ".join(" ]\n[ ", @lus_aliases)." ]";
	}

	foreach my $lus_alias (@lus_aliases) {
		expand_alias_recursive($lus_alias, $aliases_ref, ($count+1));
	}
}

expand_alias_recursive($address, \@aliases, 1);
#print Dumper(\@aliases);
%hashTemp = map { $_ => 1 } @aliases;
my @aliases_sorted_uniq = sort keys %hashTemp;
my $alias_output = join("\n", @aliases_sorted_uniq);
print "Aliases for address '$address':\n";
print "$alias_output\n";

if ($showremarks) {
	print "\n";
	print "Remarks:\n";
	print join("\n", @remarks)."\n";
}

exit;

__DATA__

	# how to sort/uniq a perl arry:
	# %hashTemp = map { $_ => 1 } @array_in;
	# @array_out = sort keys %hashTemp;

