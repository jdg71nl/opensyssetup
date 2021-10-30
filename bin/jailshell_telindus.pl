#!/usr/bin/perl

# debian: 
# apt-get install libterm-shell-perl libterm-readkey-perl  libtemplate-perl

# prep:
# > adduser telindus
# > usermod -s /usr/local/syssetup/bin/jailshell_telindus.sh telindus

# info
# http://search.cpan.org/~shlomif/Term-Shell-0.03/lib/Term/Shell.pod

package jailshell_telindus;
use strict;
use base qw(Term::Shell);

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;
use Term::ReadKey;

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
=== Allowed commands:       ping, telnet, ssh, quit                         ===
=== Allowed target subnets: 10.200.21.250/32, 10.200.30.0/24, 172.16.0.1    ===
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
	#if ($args !~ /(10\.40\.0\.|172\.16\.233\.)/) {
	if ($args !~ /(10\.200\.21\.250|10\.200\.30\.|172.16.0.1)/) {
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
	#if ($args !~ /(10\.40\.0\.|172\.16\.233\.)/) {
	if ($args !~ /(10\.200\.21\.250|10\.200\.30\.|172.16.0.1)/) {
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
	#if ($args !~ /^[0-9a-zA-Z\.\s\~\-\@]*$/) {
	if ($args !~ /(10\.200\.21\.250|10\.200\.30\.|172.16.0.1)/) {
		print '-- Illegal characters! (allowed [0-9a-zA-Z\.\s\~\-\@])'."\n";
		next;
	}
	if ($args =~ /^\s*$/) {
		next;
	}
	#if ($args !~ /(10\.40\.0\.|172\.16\.233\.)/) {
	if ($args !~ /(10\.200\.21\.250|10\.200\.30\.|172.16.0.1)/) {
		print "-- Address not allowed!\n";
		next;
	}
	my $cmd = "ssh $args";
	system($cmd);
	$o->message;
}

sub run_arpscan1 {
	my $o = shift;
	print "\n";
	my $cmd = "sudo arp-scan -I eth1 -l -i5";
	system($cmd);
	$o->message;
}

sub run_arpscan2 {
	my $o = shift;
	print "\n";
	my $cmd = "sudo arp-scan -I eth2 -l -i5";
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

'jailshell_telindus'->new('default')->cmdloop;

