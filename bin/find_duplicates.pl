#! /usr/bin/perl -w
#find2perl -type f > /usr/local/bin/find_duplicates.pl

eval 'exec /usr/bin/perl -S $0 ${1+"$@"}' if 0; #$running_under_some_shell

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use strict;
use File::Find ();
use Digest::MD5  qw(md5_hex);
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;
sub calcmd5;

my $duplist = {};
my $files = 0;
my $duplicates = 0;
my $digest = 0;

# Traverse desired filesystems
File::Find::find({wanted => \&wanted, no_chdir => 1}, '.');

#foreach my $size (()) { #keys %$duplist) {
foreach my $size (keys %$duplist) {
	if (not ref($duplist->{$size})) {
		delete $duplist->{$size};
		next;
	}
	foreach my $digest (keys %{ $duplist->{$size} } ) {
		my @list = @{ $duplist->{$size}->{$digest} };
		delete $duplist->{$size}->{$digest} if (@list == 1);
	}
	if (keys %{ $duplist->{$size} } == 0) {
		delete $duplist->{$size};
	}
}

printf STDERR ("Files: %4d, Duplicates: %4d\n",$files, $duplicates);
#print Dumper($duplist) . "\n";
foreach my $size (sort {$b <=> $a} keys %$duplist) {
	foreach my $digest (sort keys %{ $duplist->{$size} }) {
		foreach my $file (sort @{ $duplist->{$size}->{$digest} }) {
			printf ("%09d  %s  %s\n",$size,$digest,$file);
		}
		print "\n";
	}
}

exit;

sub wanted {
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = lstat($_);  
   return if ! -f $_;
	#print("$name\n");
	$files++;
	#printf("\r%80s", $name);
	
	if (not exists $duplist->{$size}) {
		# acceleration: for uniq file-size don't calc MD5
		$duplist->{$size} = $name;
		#print "name=$name\n";
	} else {

		if (not ref($duplist->{$size})) {
			# accel cache-miss: now do calc MD5 of previous file and this file
			# replace previous found name with digest
			my $prev = $duplist->{$size} ;
			$digest = calcmd5( $duplist->{$size} );
			$duplist->{$size} = {}; # replace name with hash
			$duplist->{$size}->{$digest} = [ "$prev" ]; # add digest because it is always first of list
		}

		# now calc MD5 for new name - COULD be different MD5
		$digest = calcmd5( $name );
		if (not exists $duplist->{$size}->{$digest}) {
			# add previous found $name to duplist
			$duplist->{$size}->{$digest} = [ $name ];
		} else {
			$duplicates++;
			push @{ $duplist->{$size}->{$digest} }, $name;
		}
	}
}

sub calcmd5 {
	my $filename = shift || die;
	open(FILE, "$filename") or die "Can't open '$filename': $!";
	binmode(FILE);
	my $digest = Digest::MD5->new->addfile(*FILE)->hexdigest || die;
	close(FILE);
	return $digest;
}

