#!/usr/bin/perl -w

use strict;
use Net::SMS::Mollie;

my $mollie = new Net::SMS::Mollie;

# added:
#$mollie->baseurl("https://secure.mollie.nl/xml/sms/");
#$mollie->baseurl("http://www.mollie.nl/xml/sms/");
#$mollie->gateway("1");
#$mollie->originator("RMV-Hub-01");

# needed:
$mollie->login('jdgncbvnl', 'dor9927mok');

if (my $credits = $mollie->credits) {
	print $credits." credits left!\n";
} else {
	print $mollie->resultmessage." (".
	$mollie->resultcode.")\n";
}

1;

