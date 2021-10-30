#!/usr/bin/perl

# Naam	handle	bredero	email
# Claudio Versace	c.versace	1	c.versace@hyperion-klas.nl

while (my $line=<STDIN>) {

	chomp($line);
	# better that chomp:
        $line =~ s/\s*$//g; 
	#print "$line\n";

	my @tablist = split "\t", $line;
	my $naam 	= $tablist[0] || "";
	my $handle	= $tablist[1] || "";
	my $bredero	= $tablist[2] || "";
	my $email	= $tablist[3] || "";

	if ($naam ne 'Naam') {
		print <<EOT;
INSERT INTO `mailbox` (`username`, `password`, `name`, `maildir`, `quota`, `domain`, `created`, `modified`, `active`, `login`) VALUES ('$email','tijdelijk1450','$naam','$email/',0,'hyperion-klas.nl','2011-09-22 11:00:00','2011-09-22 11:00:00',1,'$email');
INSERT INTO `alias` (`address`, `goto`, `domain`, `created`, `modified`, `active`) VALUES ('$email','$email','hyperion-klas.nl','2011-09-22 11:00:00','2011-09-22 11:00:00',1);
EOT
	}

}

