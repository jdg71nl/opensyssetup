#!/usr/bin/perl

# usage:
# > cat /tmp/hbr.txt | ./convert-xls-kml.pl > /tmp/hbr.kml

use Geo::GoogleEarth::Document;

use Data::Dumper;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse    = TRUE;

# input: tab-delimited txt:
# Naam	Adres	Huisnummer	Huisnummer Toevoeging	Postcode	Plaats
#
# tab index:
# 0		1		2				3								4			5

#my @iconlist = map {sprintf("http://maps.google.com/mapfiles/kml/paddle/%s.png", $_)} ("0", "A".."Z");
#print Dumper(\@iconlist); exit;

my $adres_lijst = {};

while (<>) {
	my $line = $_;
	chomp ($line) ;
	my @tablist = split "\t", $line;
	#print Dumper(\@tablist);
	my $struct = {};
	$struct->{"naam"}			= $tablist[0] || "";
	$struct->{"straat"}		= $tablist[1] || "";
	$struct->{"huisnummer"}	= $tablist[2] || "";
	$struct->{"toevoeging"}	= $tablist[3] || "";
	$struct->{"postcode"}	= $tablist[4] || "";
	$struct->{"plaats"}		= $tablist[5] || "";
	next if $struct->{"huisnummer"} !~ /^\d+$/;

	my $key 		= $struct->{"postcode"}.".".$struct->{"huisnummer"} ;
	$struct->{"adres"} =
		$struct->{"straat"}." ".
		$struct->{"huisnummer"}." ".
		$struct->{"postcode"}." ".
		$struct->{"plaats"}.", NL" ;

	#foreach my $x (qw/ naam straat huisnummer toevoeging postcode plaats  /) {
	# $adres_lijst->{$key}->{"$x"} = ${$x};
	#}
	$adres_lijst->{$key} = $struct;

}
#print Dumper($adres_lijst); exit;

my $document=Geo::GoogleEarth::Document->new();
my $folder=$document->Folder(name=>"Adressen");
my $icon="http://maps.google.com/mapfiles/kml/paddle/A.png";
my $iconref="styleA";
my $style=$document->Style(
	id			=> "$iconref",
	iconHref	=> "$icon",
);

foreach my $key (sort keys %{$adres_lijst} ) {

	my $struct			= $adres_lijst->{$key};
	my $description	= $struct->{"naam"} . " <br/>" . $struct->{"adres"};

	$folder->Placemark(
		address		=> $struct->{"adres"},
		name			=> $struct->{"naam"},
		description	=> $description,
		styleUrl		=> "#$iconref",
	);
}
print $document->render;

