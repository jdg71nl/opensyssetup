#!/usr/bin/perl -w

#use Data::Dumper;
use strict ;

sub help ;

my $nrARGS = $#ARGV + 1 ;	# Note: $#ARGV hold # of arguments minus 1 (so nothing is "-1")
my $arguments = join(" ", @ARGV) ;
if (( $arguments =~ /-h/ ) or ( $nrARGS < 2 )) {
	help();
	exit 1;
}

my $mode = "" ;
if ( defined $ARGV[0] ) { $mode = lc($ARGV[0]) ; }
if ( $mode eq "full" ) { $mode = "f" } ;
if ( $mode eq "page" ) { $mode = "p" } ;
if ( not (($mode eq "f") or ($mode eq "p")) ) {
	print "Invalid mode \"$mode\"\n";
	exit 1;
}

my $url = "" ;
if ( defined $ARGV[1] ) { $url = $ARGV[1] ; }
$url =~ /^http:\/\/(.*)$/i ;
my $link = $1 ;
#print "url=$url\n";
#print "link=$link\n";
if (not (defined $link)) {
	print "Invalid URL\n";
	exit 1;
}

my $output = "" ;
my $date = qx"date +d%y%m%d-%Hh%Mm%Ss" ;
chomp($date) ;
my $dir = "wgpage-" . $date ;
if ($arguments =~ /continue=([\S]*)/) {
	$dir = $1;
	if (! -d $dir) {
		die "dir=$dir is not a directoty!";
	}
	$dir =~ s/[\/\\]?$//;
} else {
	$output = qx"mkdir $dir" ;
}


print "date=$date\n";
print "dir=$dir\n";

(my $index = <<HERE_TARGET ) =~ s/^[\ \t]+//gm;
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
	<html><head><meta http-equiv="Refresh" content="0 ; url=
	./$link
	"></head><body></body></html>
HERE_TARGET
my $filename = "$dir/index.html" ;
open(FH, ">$filename") or
	die ("Cannot open file \"$filename\"! (problem with file \"$!\").\n");
print FH "$index\n" ;
close(FH);

my $common = "wget -c -p -k -np --limit-rate=100k --directory-prefix=$dir --timeout=3 --tries=3";

my $cmd = "";
if ($mode eq "p") {
	$cmd = "$common -x $url" ;
} else {
if ($mode eq "f") {
	$cmd = "$common -r $url" ;
}}
print "cmd=$cmd\n";
$output = qx"$cmd";

exit 1;

sub help {
	# (HERE-document: will erase white-space, avoid white-space of end-target)
	(my $txt = <<HERE_TARGET ) =~ s/^[\ \t]+//gm;

Usage:   wgpage.pl <page|full> <url>

This will download and convert the complete webpage to local directory.
page, p:	will download only one page
full, f:	will download entire tree

Example:
# wgpage.pl p http://www.geocities.com/scottlhenderson/spamfilter.html

This will create a new directory wgpage-<date> in the current directory.
The webpage will be saved in ./wgpage-<date>/www.geocities.com/scottlhenderson/spamfilter.html
And a link will be generated: ./wgpage-<date>/index.html that redirects to the intended page.
This way:
- you can rename/move the top-directory easily
- you can save any required URL below this top-dir.
- you can always deduce what the original location was (URL).

use this to continue a download in a previously generated dir:
# wgpage.pl p http://www.geocities.com/scottlhenderson/spamfilter.html continue=<dir>

HERE_TARGET
	print $txt ;
}
