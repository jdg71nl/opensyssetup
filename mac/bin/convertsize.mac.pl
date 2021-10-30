#!/usr/bin/perl
#jdg note: be wary of max size integer (32 bits) - better to handle in string format
while(<>){
	my $arg = $_ || ''; 
	$arg =~ /^(\d+)\s+(.*)$/;
	$n=$1;
	$f=$2;

	#mac: du -k  = 1024-byte blocks
	$n = $n * 1024;

	# max sure we can later grab 12 digits with leading zero's
	$n='x000000000000'.$n; # prevent interpretation as number, keep it a string!

	$n=~/x0*(\d{3})(\d{3})(\d{3})(\d{3})$/;
	printf"%03d.%03d.%03d.%03d  %s\n",$1,$2,$3,$4,$f;
}

