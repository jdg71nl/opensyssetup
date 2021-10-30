#!/usr/bin/perl -w

use Time::Local;

$time = $ARGV[0] || '';
$time = time() if ($time !~ /^\d+$/);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time) ;
my $shortyear = ($year - 100) % 100;
my $timetag = sprintf("d%02d%02d%02d-%02d%02d%02d", $shortyear, $mon+1, $mday, $hour, $min, $sec);
my $prettytime = localtime($time) ;  # scalar-context

print "Now::    Epoch seconds: $time, Time-tag: $timetag, Local time: $prettytime\n";

$sec = 0;
$min = 0;
$hour = 0;
$time = timelocal($sec,$min,$hour,$mday,$mon,$year);
print "0h00 yesterday:: Epoch: ". ($time-86400)."\n";
print "0h00 today::     Epoch: ". ($time      )."\n";
print "0h00 tomorrow::  Epoch: ". ($time+86400)."\n";

