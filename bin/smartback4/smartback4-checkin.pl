#!/usr/bin/perl -w
#= smartback4-checkin.pl

use strict;
use warnings;

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use File::Basename ;
use Cwd 'abs_path'; # also resolves symlinks
#use Cwd 'getcwd';
#use Data::Dumper;
#use Getopt::Long;

my $basename = basename(abs_path($0)) ; # only name, abs_path resolves symlinks

if ($> != 0) { # $> is $EUID
	print "$basename: skipped because not-root\n";
	exit;
}

#qx"logger $basename started";
#my $basedir = dirname(abs_path($0)); # without trailing slash

#my $sysbackdir = "/var/syssetup/thissystem/root";
#print getcwd() . "\n";

my $list = "/etc/smartback4/sources.txt" ;

#print "$basename:\n";

sub checkin {
	my $file = shift;
	return if not defined $file;
	return if $file eq '';

	my $absfile = abs_path($file);

	if (-l $file) {
		print "$basename: symlink skipped: '$file' -> '$absfile' (but will consider the target) \n";
	}
	if (-d $absfile) {
		#print "$basename: directory skipped: '$absfile' \n";
		#print "skipped: $absfile is a directory (you can use 'find -type f | $basename -')\n";
		system "echo \"$absfile\/\" >> $list";
		print "$basename: checked in directory \"$absfile\/\" \n";
	} elsif (not -f $absfile) {
		print "$basename: non-regular file skipped: '$absfile' \n";
		#print "skipped: $absfile is not a regular file\n";
	} else {
		#system "find \"$absfile\" -print0 | cpio -p0dum --quiet $sysbackdir";
		system "echo \"$absfile\" >> $list";
		print "$basename: checked in file \"$absfile\" \n";
	}
}

if (exists $ARGV[0] and $ARGV[0] eq '-') {
	while (my $x=<>) {
		chomp $x;
		checkin($x);
	}
} else {
	foreach my $f (@ARGV) {
		checkin($f);
	}
}

#system "~/opensyssetup/bin/make-file-sorted-uniq.sh $list"
system "~/opensyssetup/bin/smartback4/_smartback4-sortuniq.sh $list"

#

