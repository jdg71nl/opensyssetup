#!/usr/bin/perl
# convertsize.pl
#jdg note: be wary of max size integer (32 bits) - better to handle in string format
#
#d180808 add kilobytes option for Mac 'du -k' = kilobytes instead of Linux 'du -b' = bytes
my $name = __FILE__ ; #print "name=$name\n";
my $k = ( $name =~ /\-k/ ? 1 : 0); # detect symlink: ln -s convertsize.pl convertsize-k.pl
print "k=$k\n" if $k;
#
while(<>){
	my $s = '000000000000' . $_; # max sure we can later grab 12 digits with leading zero's
	$s =~ /^(\d+)\s+(.*)$/;
	$n = 'x'.$1; # prevent interpretation as number, keep it a string!
	$n = $n . '000' if $k;
	$f = $2;
	$n =~ /x0*(\d{3})(\d{3})(\d{3})(\d{3})$/;
	printf"%03d.%03d.%03d.%03d  %s\n",$1,$2,$3,$4,$f;
}

