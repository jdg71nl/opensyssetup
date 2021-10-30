#! /usr/bin/env perl 
# usage:
# cat file1.csv | ./convert_csv_excel.pl > file2.csv
#
while (<>) {
	my $line = $_;
	chomp($line);
	$line =~ s/","/";"/g ;
	$line =~ s/(\d{4})(\d{2})(\d{2})/$3-$2-$1/;
	print "$line\n";
}


