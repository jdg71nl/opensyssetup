#!/usr/bin/perl

use strict;
use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use DBI;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

#######################################################################
# read MySQL
#
my $dbh = open_dbi();
my $sql = "";
my $db_result = "";

$sql = qq{
	SELECT address, goto
	FROM alias
	ORDER BY address ASC
};
#$db_result = $dbh->selectrow_hashref($sql);
my $aliases = $dbh->selectall_arrayref(
	$sql,
	{ Slice => {} }
);
foreach my $alias ( @$aliases ) {
	my $address = $alias->{address};
	my $goto = $alias->{goto};
	$goto =~ s/,/,\n \t/g;
	if ($address ne $goto) {
		print "/$address/   $goto \n";
	}
}

sub open_dbi {
	my $db      = 'postfix';
	my $db_user = 'postfix';
	my $db_pwd  = 'pwd';
	my $dbh = DBI->connect("dbi:mysql:$db:localhost", "$db_user", "$db_pwd", {RaiseError => 0, PrintError => 0} )
	or die "Cannot connect to the database" ;
	return $dbh;
}


sub close_dbi {
	my $dbh = shift(@_);
	$dbh->disconnect or err_trap("Cannot disconnect from the database");
}

