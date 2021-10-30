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

my $dbh;
my $sql = '';
my $db_result = {};

print "not yet done..\n";
exit;

#############################################################################
$dbh = open_dbi();

###
print "Checking database version...\n";
$sql = qq{ SELECT conf_dbversion_n FROM tbl_config; };
$db_result = $dbh->selectrow_hashref($sql);
#my $conf_dbversion_n = $db_result->{'conf_dbversion_n'} || 0;

#print "Done.\n";
close_dbi($dbh);
exit;
#############################################################################


#############################################################################
# open_dbi
#
sub open_dbi {
   my $db      = 'dbname';
   my $db_user = 'dbusername';
   my $db_pwd  = 'dbuserpwd';
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

   # 0 EMERG      Emergency: system is unusable
   # 1 ALERT      Alert: action must be taken immediately
   # 2 CRIT       Critical: critical conditions
   # 3 ERR        Error: error conditions
   # 4 WARNING    Warning: warning conditions
   # 5 NOTICE     Notice: normal but significant condition
   # 6 INFO       Informational: informational messages
   # 7 DEBUG      Debug: debug-level messages

#   my $hash = shift || die;
#   my $sql  = qq{
#			INSERT INTO tbl_log
#			(log_time_t, log_level_n, log_line_s, log_beheerder_id_n, log_klant_id_n) VALUES
#			(NOW(), ?, ?, ?, ?);
#       };
#   $dbh->do($sql,
#		$hash->{log_level_n},
#		$hash->{log_line_s},
#      $hash->{log_beheerder_id_n},
#      $hash->{log_klant_id_n}
#   );

   my $line = shift || 'empty logline';
   my $sql  = qq{
			INSERT INTO tbl_log
			(log_time_t, log_level_n, log_line_s, log_beheerder_id_n, log_klant_id_n) VALUES
			(NOW(), 6, ?, 0, 0);
        };
   $dbh->do( $sql, undef, $line );

}

#############################################################################
#############################################################################

__DATA__

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

