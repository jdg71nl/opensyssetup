#!/usr/bin/perl

opendir(DIR, ".");
while($name = readdir(DIR)) {
	next if $name =~ /_scr.jpg/i;
	next if $name =~ /_th.jpg/i;

	if ($name =~ /.jpg/i ) {
		#next if $name =~ /mvi/i;
		#$name =~ s/.jpg//i ;
		push(@jpgfiles, $name);
	}
}
close(DIR);

foreach $file (sort @jpgfiles) {

	my $th_file = $file;
	$th_file =~ s/^(.*?)(\.jpg)$/$1_th$2/i;

	if (-e $th_file) {
		print "$th_file already exists.\n";
	} else {  
		$cmd = "convert -geometry 150x150 '$file' '$th_file'" ;
		print "$cmd ...\n";
		system "$cmd";
		print " Done!\n" ;
	}

	my $scr_file = $file;
	$scr_file =~ s/^(.*?)(\.jpg)$/$1_scr$2/i;

	if (-e $scr_file) {
		print "$scr_file already exists.\n";
	} else {  
		$cmd = "convert -geometry 800x600 '$file' '$scr_file'" ;
		print "$cmd ...\n";
		system "$cmd";
		#system "convert","-geometry","800x600", "${file}.jpg", "${file}_scr.jpg" ;
		print " Done!\n" ;
	}
}

exit;

