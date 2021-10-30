#!/usr/bin/perl

# -----------------------------------------------------------------------------
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

# -----------------------------------------------------------------------------

my $domainlist_file = "/etc/named-masterslavelist.txt";

system("cat $domainlist_file | egrep -v '^[[:space:]]*\$' | sort | uniq > $domainlist_file.sort");
system("cat $domainlist_file.sort > $domainlist_file");

open FILE, "<", "$domainlist_file" or die $!;
my @domainlist = ();
while (<FILE>) { 
	push @domainlist, $1 if /^\s*([\w\d-.]+)\s*$/;
}
#print Dumper(\@domainlist); exit;

# -----------------------------------------------------------------------------

system("diff -us $domainlist_file.previous $domainlist_file");
system("cat $domainlist_file > $domainlist_file.previous");

# -----------------------------------------------------------------------------
# Template Toolkit
# CentOS: yum install perl-Template-Toolkit
# man Template
use Template;
my $tt2_config = {
   ABSOLUTE    => 1,
};
#  POST_CHOMP  => 1,
my $tt2 = Template->new($tt2_config);

my $tt2_vars = {
	domainlist => \@domainlist
};

my $tt2_inputfile    = "/etc/named.conf.tt2";
my $tt2_outputfile   = "/etc/named.conf.generated";
$tt2->process($tt2_inputfile, $tt2_vars, $tt2_outputfile) || warn $tt2->error()."\n";

system("cd /etc/ ; cat $tt2_outputfile > named.conf");


