#!/usr/bin/perl -w
#= _smartback4-expand.pl

use strict;
#use warnings;

use File::Basename ;
use Cwd 'abs_path'; # also resolves symlinks
#use Cwd 'getcwd';

#use Data::Dumper;
#$Data::Dumper::Indent = 1;
#$Data::Dumper::Sortkeys = 1;
#$Data::Dumper::Terse = 1;

use File::Spec;

sub expand {
	my $path = shift;
	return if not defined $path;
	return if $path eq '';
	return if $path =~ /^\s*$/;
	return if $path =~ /^\s*[#!;.]/;

	my $abspath = abs_path( $path ) || '';
	return if $abspath eq '/';
	#print STDERR "path: $path, abspath: $abspath\n";

	if (-l $path) {
		warn "$0: '$path' is a symlink (to '$abspath') and therefor skipped!";
		return;
	}
	my $is_dir = 0;
	if (-f $abspath) {
		$is_dir = 0;
	} elsif (-d $abspath) {
		$is_dir = 1;
	} else {
		warn "$0: '$abspath' is not a regular file or a directory and therefor skipped!";
		return;
	}

	my @dirs = File::Spec->splitdir( $abspath );
	my $dirsize = @dirs;
	#print STDERR "abspath: $abspath\n";
	#print STDERR Dumper(@dirs);

	my @full_dirs = ();
	for (my $i = 0; $i < $dirsize; $i++) {
		push @full_dirs, File::Spec->catfile( @dirs[0..$i] );
	}

	my $full_dirsize = @full_dirs;
	for (my $i = 1; $i < ($full_dirsize-1); $i++) {
		print "+ $full_dirs[$i]/\n";
	}
	if ($is_dir) {
		print "+ $full_dirs[$full_dirsize-1]/\n";
		print "+ $full_dirs[$full_dirsize-1]/**\n";
	} else {
		print "+ $full_dirs[$full_dirsize-1]\n";
	}

}

while (my $path=<>) {
	chomp $path;
	$path =~ s/^\s*//;
	$path =~ s/\s*$//;
	expand($path);
}

exit 0; # success

