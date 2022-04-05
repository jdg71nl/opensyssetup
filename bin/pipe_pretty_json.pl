#!/usr/bin/perl
#= pipe_pretty_json.pl
# NOTE: can also use 'jq', sudo apt install jq
use strict;
use warnings;
use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
# use Data::Dumper;   # apt install libdata-dump-perl
# $Data::Dumper::Indent = 1;
# $Data::Dumper::Sortkeys = TRUE;
# $Data::Dumper::Terse = TRUE;
use lib qw(..);
use JSON qw( );   # apt install libjson-perl  # https://metacpan.org/pod/JSON
my $json = JSON->new;
my $input_json = <STDIN>;
my $input_data = $json->decode($input_json);
# print Dumper($input_data); # + "\n";
#
# https://code-maven.com/json-beautifier
#!/usr/bin/env perl
print JSON->new->ascii->pretty->encode($input_data);
#
#-EOF
