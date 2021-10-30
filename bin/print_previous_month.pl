#!/usr/bin/perl

use Time::Local;
my $now = time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($now) ;

#my $longyear = $year + 1900;
#my $month_str= sprintf("%02d-%04d", $mon+1,$longyear);
my $first_second_of_month = timelocal(0,0,0,1,$mon,$year);
#my $first_second_of_month_str = scalar localtime($first_second_of_month);
#my $last_second_of_month = timelocal(0,0,0,1,$mon+1,$year)-1;
#my $last_second_of_month_str = scalar localtime($last_second_of_month);
my $last_second_of_prev_month = timelocal(0,0,0,1,$mon,$year)-1;

use POSIX qw(strftime);
# see:  man 3 strftime

#my $now_string = strftime "%a %b %e %H:%M:%S %Y", localtime;
my $prev_month     = strftime "%m-%Y", localtime($last_second_of_prev_month);
my $prev_month_str = strftime "%b-%Y", localtime($last_second_of_prev_month);

my $ARGV0 = $ARGV[0] || '';
if ($ARGV0 =~ /string/i) {
	print "$prev_month_str\n";
} else {
	print "$prev_month\n";
}

