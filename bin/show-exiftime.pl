#!/usr/bin/perl

# see also 'exiftool.quicky'

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;

use Image::ExifTool qw(:Public);
$file = shift;
my $info = ImageInfo($file, 'EXIF:Time:*');

print Dumper(\$info);

