#!/usr/bin/perl

my $PWD="";
print "Type a password for MySQL user 'jdg': ";
$PWD = <>;
chomp $PWD;

my $SQL = <<HERE;
GRANT ALL PRIVILEGES ON *.* TO 'jdg'\@'%' IDENTIFIED BY '$PWD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'jdg'\@'localhost' IDENTIFIED BY '$PWD' WITH GRANT OPTION;
UPDATE mysql.user SET Password=PASSWORD('$PWD') WHERE User='jdg';
FLUSH PRIVILEGES;
HERE

$SQL =~ s/\n/ /gc;

my $CMD = "echo \"$SQL\" | mysql -u root -p \n";

print "\n";
print "CMD: $CMD";
print "\n";
print "Type the 'root' password for MySQL:\n";
system ($CMD);

