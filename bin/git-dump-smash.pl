#!/usr/bin/perl
#= git-dump-smash.pl
# 2024(c) John@de-Graaff.net 

my $LAST="", $ADD="", $REM="", $FILE="";
while (my $LINE=<STDIN>) { 
  chomp($LINE);
  # next if ($LINE eq "");
  if ($LINE eq "") {
    print "\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\"\n";
    next;
  }
  if ($LINE =~ /^"/) {
    $LAST=$LINE;
    ($ADD,$REM,$FILE) = ("","","");
  } else {
    ($ADD,$REM,$FILE) = split /\s/, $LINE;
    if ($ADD ne "-" && $REM ne "-" && ($ADD ne "0" || $REM ne "0")) {
      print "$LAST,\"added:$ADD\",\"removed:$REM\",\"file:$FILE\"\n";
    }
  }
}

#-eof
