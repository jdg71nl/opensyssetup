#!/usr/bin/perl
use String::Random;
my $s=String::Random->new;
foreach my $n ( 1..12 ) {
        print $s->randregex('[01]{64}'),"\n";
}

