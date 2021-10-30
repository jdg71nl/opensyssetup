#!/usr/bin/perl -w

# -- Install Perl modules:
# > perl -MCPAN -eshell
# cpan> install Net::SMS::Mollie

# -- Documentation:
# http://www.mollie.nl/support/documentatie/sms-diensten/sms/http/

# geldige tekens:
# http://en.wikipedia.org/wiki/GSM_03.38


use strict;
use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use Net::SMS::Mollie;

# http://perldoc.perl.org/Getopt/Long.html
use Getopt::Long;

use File::Basename ;
my $basename = basename($0);

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

my $allopts = join " ", @ARGV;
my %options = ();
GetOptions(\%options, 'originator=s', 'login=s', 'pwd=s', 'recipient=s', 'msg=s', 'h|help');

sub help {
	my $msg = shift || '';
	print "Error: $msg\n" if $msg;
	print "\n";
	print "Usage: $basename --originator=<string> --login=<string> --pwd=<string> --recipient=<telnumber> --msg=<string> \n";
	print "example: $basename --originator='TWS ICT' --login='login' --pwd='pwd' --recipient='0612345678' --msg='This is an SMS' \n";
	print "\n";
	exit 0;
}
help() if (exists $options{h} or exists $options{help});

my $originator = $options{originator} || '';
my $login		= $options{login} || '';
my $pwd			= $options{pwd} || '';
my $recipient	= $options{recipient} || '';
my $msg			= $options{msg} || '';

chomp($recipient);

help() if (not $originator);
help() if (not $login);
help() if (not $pwd);
help() if (not $recipient);
help() if (not $msg);
help("recipient '$recipient' is not a 10-digit telephone number starting with 0") if ($recipient !~ /0\d{9}/);

print "-- Sending to Mollie...\n";

my $mollie = new Net::SMS::Mollie;
# added:
#default: $mollie->baseurl("https://secure.mollie.nl/xml/sms/");
$mollie->baseurl("https://secure.mollie.nl/xml/sms/");
#$mollie->baseurl("http://www.mollie.nl/xml/sms/");
$mollie->gateway("1");
$mollie->originator($originator);
# needed:
$mollie->login($login, $pwd);
$mollie->recipient($recipient);

#print Dumper(\$mollie) ; exit;

$mollie->send($msg);

#foreach(qw/1234567890 0987654321 1292054283/) {
#	$mollie->recipient($_);
#}

if ($mollie->is_success) {
	print "-- Successfully sent message to ".$mollie->successcount." number(s)!\n";
} else {
	print "-- Something went horribly wrong!\n".
	"Error: ".$mollie->resultmessage." (".$mollie->resultcode.")"."\n";
}

1;

