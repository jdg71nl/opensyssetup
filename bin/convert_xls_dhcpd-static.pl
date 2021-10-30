#!/usr/bin/perl

my $output = $ARGV[0] || die 'provide arg: dump|dhcpd|ctl';

# Example input from XLS (with tabs between cells):
# Name	MAC	IP	Location	Serial	Naam in CTL
# PD-01	00:03:52:0a:01:52	172.16.15.1	CH2 lokaal 07	K138-00156	K138-00156

while (my $line=<STDIN>) {
chomp($line);
#print "$line\n";
$line =~ /^([\S]+)\s+([\S]+)\s+([\S]+)\s+([^\t]+)\s+([\S]+)\s+([\S]+).*$/i;
my $apname  = $1;
my $mac     = $2;
my $ip      = $3;
my $loc     = $4;
my $serial  = $5;
my $ctlname = $6;

$mac = uc($mac);

if ($output eq 'dump') {
print "apname=$apname, mac=$mac, ip=$ip, loc=$loc, serial=$serial, ctlname=$ctlname\n";
}

if ($output eq 'dhcpd') {
print "host WLAN-AP-$apname { hardware ethernet $mac; fixed-address $ip; }\n";
}

if ($output eq 'ctl') {
print <<EOT;
controlled network ap "$ctlname" $mac
ap name $apname
contact "john.de.graaff@networkconcepts.nl"
location "$loc"
end
EOT

}

}

