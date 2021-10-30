#!/usr/bin/perl -w

use strict;
no strict 'refs';
use constant TRUE  => 1;    # perl: <>0
use constant FALSE => 0;

use POSIX;
use DBI;
use Data::Dumper;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse    = TRUE;

# DB
my $dbh = open_dbi();
close_dbi($dbh);

#############################################################################
die if not $dbh;

my $sql = qq{
                UPDATE rmvunits SET checkedin=$checkedin WHERE serial=$rmvuserial
        };
$dbh->do($sql);

#############################################################################
$sql = qq{
                SELECT serial, customername
                FROM rmvunits
        };
$sth = $dbh->prepare($sql);
$sth->execute();
while ( @row = $sth->fetchrow_array ) {
   my $serial = $row[0];
   $serial = sprintf( "%03d", $serial );
   $rmvu_status{$serial} = {};
   $rmvu_status{$serial}->{customername} = $row[1];
}
$sth->finish();

#############################################################################

$sql = qq{
        SELECT group_id
        FROM groups
        WHERE cert_cn = '$cert_cn'
};
$db_result = $dbh->selectrow_hashref($sql);
my $group_id = $db_result->{group_id} || 0;

#############################################################################
# open_dbi
#
sub open_dbi {
   my $db      = 'ovpnclientdb';
   my $db_user = 'ovpnscript';
   my $db_pwd  = 'jf732hdk';
   my $dbh     =
     DBI->connect( "dbi:mysql:$db:localhost", "$db_user", "$db_pwd",
      { RaiseError => 0, PrintError => 0 } )
     or die "Cannot connect to the database";
   return $dbh;
}
#############################################################################

#############################################################################
# close_dbi
#
sub close_dbi {
   my $dbh = shift(@_);
   $dbh->disconnect or err_trap("Cannot disconnect from the database");
}
#############################################################################

sub db_log {
   my $hash = shift || die;
   my $sql  = qq{
                INSERT INTO clientlog
                VALUES (?,?,?,?,?,?)
        };
   $dbh->do( $sql, undef, $hash->{time}, $hash->{client_id}, $hash->{group_id},
      $hash->{connected}, $hash->{pub_ip}, $hash->{log}, );
}

#############################################################################
#############################################################################

