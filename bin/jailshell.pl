#!/usr/bin/perl

# debian: 
# apt-get install libterm-shell-perl libterm-readkey-perl libtemplate-perl libconfig-simple-perl 

# prep:
# > adduser junipersupport
# > usermod -s /usr/local/syssetup/bin/jailshell.sh junipersupport
# > cd /etc/jailshell/
# > cp -a telindussupport.ini junipersupport.ini
# > vi junipersupport.ini 
# [config]
# address = '10.200.21.250'


# info
# http://search.cpan.org/~shlomif/Term-Shell-0.03/lib/Term/Shell.pod

package jailshell;
use strict;
use base qw(Term::Shell);

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;
use Term::ReadKey;

my $username =  $ENV{'LOGNAME'}; 
my %Config = {};
use Config::Simple;
Config::Simple->import_from("/etc/jailshell/$username.ini", \%Config);
#
# > cat /etc/jailshell/root.ini             
# [config]
# address = "/asd/"
#
# perl: Dumper(\%Config) ;
# {
#  'HASH(0x8355818)' => undef,
#  'config.address' => '/asd/'
# }
#
my $re_addr = $Config{'config.address'} || '//';
#print "re_addr=$re_addr\n";exit;

sub init {
    my $o = shift;
    #$o->remove_handlers("run_squiggle");
    $o->{API}{match_uniq} = 0;	# allow only exact matches
	 $o->message;
}

# The default method (when you enter a blank line). This command is not shown
# in the help or in completion lists.
sub run_ {
	my $o = shift;
	$o->message;
}

sub catch_run {
    my $o = shift;
    my $cmd = shift;
    #print "NOTE: catch_run() called. Emulating $cmd()\n";
    #print Dumper \@_;
	 $o->message;
}

# You can override the prompt
sub prompt_str {
    my $o = shift;
    #$o->{SHELL}{num}++;
    #"test:$o->{SHELL}{num}> ";
	 #"type number/letter/command> ";
	 "command> ";
}

sub message {
	my $o = shift;

	my $length_indicator = <<EOT;
0        1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
EOT

	print <<EOT;

===============================================================================
=== Restricted shell                                                        ===
=== Allowed commands:       ping, telnet, ssh, cat, less, radview, quit     ===
===============================================================================
EOT
}

sub run_v {
	my $o = shift;
	# VPN

	print "(not yet implemented)\n";
}

sub run_ping {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	if ($args !~ /$re_addr/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "ping $args";
	system($cmd);
	$o->message;
}

sub run_telnet {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	if ($args !~ /$re_addr/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "telnet $args";
	system($cmd);
	$o->message;
}

sub run_ssh {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	if ($args !~ /$re_addr/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "ssh $args";
	system($cmd);
	$o->message;
}

sub run_cat {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	if ($args !~ /$re_addr/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "cat /var/log/HOSTS/$args.log.txt";
	system($cmd);
	$o->message;
}

sub run_less {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	if ($args !~ /$re_addr/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "less /var/log/HOSTS/$args.log.txt";
	system($cmd);
	$o->message;
}

sub run_radview {
	my $o = shift;
	my $args = join(" ", @_);
	print "\n";
	if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	my $cmd = "/usr/local/syssetup/bin/radview_twsnet.sh $args";
	system($cmd);
	$o->message;
}

sub run_exit {
	ReadMode 'normal';
	exit;
}
sub alias_exit { qw(e q quit \q) }

# ------+++------------+++------------+++------------+++------------+++------
package main;

#use Data::Dumper;
use Term::ReadKey;

'jailshell'->new('default')->cmdloop;

