#!/usr/bin/perl -w
use Time::Local;
my $file = $ARGV[0] || "touch_file.txt";
my $time = time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time) ;
my $longyear = $year + 1900;
my $touchtime = sprintf("%04d%02d%02d%02d%02d", $longyear, $mon+1, $mday, $hour, $min);
unlink $file if -f $file;
open (FILE, ">$file");
print FILE "$touchtime\n";
close FILE;
# mac:
qx"touch $file";

