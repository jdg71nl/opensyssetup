#!/usr/bin/perl -w

use Time::Local;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time()) ;

# set to 12am-GMT which is when rotatelogs will rotate
$sec = 0;
$min = 0;
$hour = 0;
my $time = timegm($sec,$min,$hour,$mday,$mon,$year);

print "time = $time\n";
system "cd /var/log/httpd/ ; ln -sf access_log.$time access_log";

# WARNING !!!!!! --> edit /etc/logrotate.d/httpd and disable logrotate for these files

