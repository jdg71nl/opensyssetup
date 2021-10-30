#!/usr/bin/perl

use Geo::GoogleEarth::Document;

use Data::Dumper;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse    = TRUE;

# input: tab-delimited txt:
# Postcode	Straat	Huisnummer	Toevoeging	Aansluitgebied	AP	DP	Graafplanning	Start Datum HAS
# 3823HS	De Horizon	1		2	AMF-JFW	AMF-JFW-DP06	1-3-10	28-5-10
#
# tab index:
# Postcode	Straat	Huisnummer	Toevoeging	Aansluitgebied	AP	DP	Graafplanning	Start Datum HAS
# 0			1			2				3				4

my @iconlist = map {sprintf("http://maps.google.com/mapfiles/kml/paddle/%s.png", $_)} ("0", "A".."Z");
#print Dumper(\@iconlist); exit;

my $straat_lijst = {};

# read input and construct list of streets
while (<>) {
	my $line = $_;
	chomp ($line) ;
	my @tablist = split "\t", $line;
	my $postcode	= $tablist[0] || "";
	my $straat		= $tablist[1] || "";
	my $huisnummer	= $tablist[2] || "";
	my $toevoeging	= $tablist[3] || "";
	my $wijk 		= $tablist[4] || "";
	next if $huisnummer !~ /^\d+$/;
	next if $wijk !~ /^\d+$/;

	#if (! exists $straat_lijst->{$wijk}->{$straat}) {
	#	$straat_lijst->{$wijk}->{$straat} = {};
	#}

	my $evenref = "even";
	$evenref = "oneven" if ($huisnummer % 2);
	
	if (! exists $straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}) {
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"laagste"}->{"huisnummer"} = 9999;
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}->{"huisnummer"} = 0;
	}
	if ($huisnummer > $straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}->{"huisnummer"}) {
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}->{"huisnummer"}	= $huisnummer;
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}->{"postcode"}	= $postcode;
	}
	if ($huisnummer < $straat_lijst->{$wijk}->{$straat}->{$evenref}->{"laagste"}->{"huisnummer"}) {
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"laagste"}->{"huisnummer"}	= $huisnummer;
		$straat_lijst->{$wijk}->{$straat}->{$evenref}->{"laagste"}->{"postcode"}	= $postcode;
	}

}
#print Dumper($straat_lijst); exit;

my $document=Geo::GoogleEarth::Document->new();
my @iconreflist = ();

foreach my $wijk (sort keys %{$straat_lijst} ) {

	my $folder=$document->Folder(name=>"Wijk $wijk");

	foreach my $straat (sort keys %{ $straat_lijst->{$wijk} } ) {

		foreach my $evenref ("even", "oneven") {
			foreach my $hoogref ("hoogste", "laagste") {

				my $huisnummer	= $straat_lijst->{$wijk}->{$straat}->{$evenref}->{$hoogref}->{"huisnummer"};
				my $postcode	= $straat_lijst->{$wijk}->{$straat}->{$evenref}->{$hoogref}->{"postcode"};
				next if $huisnummer == 0;
				next if $huisnummer == 9999;
				next if (
					($hoogref eq "hoogste") and 
					($straat_lijst->{$wijk}->{$straat}->{$evenref}->{"hoogste"}->{"huisnummer"} == $straat_lijst->{$wijk}->{$straat}->{$evenref}->{"laagste"}->{"huisnummer"})
				);

				my $address = "$straat $huisnummer $postcode Amersfoort, NL";
				my $icon=$iconlist[$wijk];
				my $iconref=sprintf "style%s", $wijk;

				if (! grep(/^$iconref$/,@iconreflist) ) {

					my $style=$document->Style(
						id			=> "$iconref",
						iconHref	=> "$icon",
					);
					push @iconreflist, $iconref;
				}
				$folder->Placemark(
					address		=> "$address",
					name			=> "$address",
					description	=> "wijk $wijk",
					styleUrl		=> "#$iconref",
				);
			}#hoogref
		}#wijk
	}#straat
}
print $document->render;

