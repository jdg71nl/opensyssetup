#!/usr/bin/perl

if ( !$ARGV[0] ) {
	print "Usage: make_thumb_page.pl \"title\" > index.html \n";
	exit;
}
my $title = $ARGV[0] || "";

opendir(DIR, ".");
while($file = readdir(DIR)) {
	push(@thumb_names, $1) if ($file =~ /^(.*?)_th\.jpg/i);
}
close(DIR);

foreach $name (sort @thumb_names) {
	push(@photos, {name=>$name,ext=>"jpg"}) if (-e "$name.jpg");
	push(@photos, {name=>$name,ext=>"jpg"}) if (-e "${name}_scr.jpg");

	push(@videos, {name=>$name,ext=>"avi"}) if (-e "$name.avi");
	push(@videos, {name=>$name,ext=>"wmv"}) if (-e "$name.wmv");
	push(@videos, {name=>$name,ext=>"mpg"}) if (-e "$name.mpg");
}

print "<html><head><title>$title</title></head>\n";
print "<body bgcolor=\"#FFFF80\"><div align=\"center\">\n";
print "<H1>$title</H1>\n";

print "<H2>Photo's</H2>\n";
print "<table border=\"1\" bordercolor=\"#000000\">\n";
print "<tr>\n";
$column_count = 0;
foreach $photo (@photos) {
	$name = $photo->{name};
	print "<td align=\"center\"><a href=\"${name}_scr.jpg\">";
	print "<img src=\"${name}_th.jpg\" border=\"0\"></a>";
	print "<font size=\"-1\" color=\"#0000FF\">";
	print "<br>$name.jpg";
	$size_scr  = (stat("${name}_scr.jpg"))[7] / 1024;
	print "<br><a href=\"${name}_scr.jpg\">Screen-size</A> ";
	printf "(%d KB)", $size_scr;
	if (-e "${name}.jpg") {
		$size_full = (stat("$name.jpg"))[7]     / 1024 ;
		print "<br><a href=\"$name.jpg\">Full-size</A> ";
		printf "(%d KB)", $size_full;
	}
	print "</font></td>\n";

	$column_count++;
	if ($column_count eq 5) {
		print "</tr><tr>\n";
		$column_count = 0;
	}
}
print "</tr>\n";
print "</table>\n";

if (@videos) {

print "<H2>Video's</H2>\n";
print "<table border=\"1\" bordercolor=\"#000000\">\n";
print "<tr>\n";
$column_count = 0;
foreach $video (@videos) {
	$name = $video->{name};
	$ext = $video->{ext};
	
	$size  = (stat("${name}.$ext"))[7] / 1024;
	print "<td align=\"center\"><a href=\"${name}.$ext\">";
	print "<img src=\"${name}_th.jpg\" border=\"0\"></a>";
	print "<font size=\"-1\" color=\"#0000FF\">";
	print "<br>$name.$ext";
	print "<br><a href=\"${name}.$ext\">Download</A> ";
	printf "(%d KB)", $size;
	print "</font></td>\n";

	$column_count++;
	if ($column_count eq 5)
	{
		print "</tr><tr>\n";
		$column_count = 0;
	}
}
print "</tr>\n";
print "</table>\n";

} # if videos

print "</div>\n";
print "</body></html>\n";

exit;

