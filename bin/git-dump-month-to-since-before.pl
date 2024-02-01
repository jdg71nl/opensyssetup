#!/usr/bin/perl
#= month-to-since-before.pl
# 2022(c) John@de-Graaff.net 

# Usage, and Example: 
# OLD: > ./month-to-since-before.pl 2022-02
# OLD: 2022-01-31 2022-03-01
# > ./bin/month-to-since-before.pl 2022-02
# 2022-02-01 2022-03-01

# debian: > sudo apt install -y libdatetime-perl
use DateTime;

my $arg1 = join "-", @ARGV;
if ($arg1 eq "") { $arg1 = "1970-01"; }

#print "arg1 = $arg1 \n"; exit;

#my( $year, $month ) = qw( 2012 2 );
my( $year, $month ) = split /\-/, $arg1;

my $date_before = DateTime->new(
  year  =>  $year,
  month => $month,
  day   => 1,
);

# $date_before->add( months => 1 )->subtract( days => 1 );
$date_before->add( months => 1 );

my $date_since = $date_before->clone;

# $date_since->add( months => 1 )->subtract( days => 1 );
# $date_since->subtract( months => 1 )->subtract( days => 1 );
$date_since->subtract( months => 1 );

# print "date_since=" .  $date_since->ymd('-')  . "\n";
# print "date_before=" . $date_before->ymd('-') . "\n";

print $date_since->ymd('-') . " " . $date_before->ymd('-') . "\n";

#-EOF

