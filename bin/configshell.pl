#!/usr/bin/perl

# debian: 
# apt-get install libterm-shell-perl libterm-readkey-perl libnetaddr-ip-perl libnet-arp-perl libtemplate-perl

package rmvconfigshell;
use strict;
use base qw(Term::Shell);

use lib '/rmv/bin/perl_libs';
use RMV::Config;
my $version = &RMV::Config::read_version() || "read_version failed";
my $interface_quantity = 0;

use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;
use Term::ReadKey;

use Net::ARP;

my $timeout = 300;
my $rmvhub = '2.1.0.1';

sub init {
    my $o = shift;
    #$o->remove_handlers("run_squiggle");
    $o->{API}{match_uniq} = 1;	# allow only exact matches
    $o->{API}{check_idle} = $timeout;	# run on_idle() every X seconds
	 $o->message;
}

sub idle {
	my $o = shift;
	#$o->{SHELL}{num}++;
	print <<EOT;


<TIME-OUT> (idle after $timeout seconds)

EOT
	sleep 1;
	ReadMode 'normal';
	exit;

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

sub readconfig {
	my $o = shift;

	my $unit = &RMV::Config::read_unit();
	$interface_quantity = $unit->{interface_quantity};
	return $unit;
}
	
sub writeconfig {
	my $o = shift;

	my $unit = shift || die;
	&RMV::Config::write_unit($unit);
}

sub message {
	my $o = shift;
	my $unit = $o->readconfig();

	my $ltime = localtime(time());
	#my $time = sprintf("%29s", $ltime);

	my $gw = "";
	$gw ||= $unit->{lan1}->{routes}->{'0.0.0.0/0'};
	$gw ||= $unit->{lan2}->{routes}->{'0.0.0.0/0'};
	$gw ||= $unit->{lan3}->{routes}->{'0.0.0.0/0'};
	$gw ||= "<undefined>";

	my $apply_msg = ($unit->{needapply} ? "(config changed, apply needed)":"(no changes)");
	
	my $rmvserial_msg = "";
	my $rmvserial = sprintf("%03d", $unit->{rmvserial} );
	if (-f "/etc/openvpn/rmv_hub1/rmvu$rmvserial.vpncert.rmv2.crt") {
		$rmvserial_msg = "(certificates are present)";
	} else {
		$rmvserial_msg = "(certificates NOT present!)";
	}

	if (0) {
		use Net::Ping;
		my $p = Net::Ping->new("tcp", 1);
		$p->{port_num} = 873; # rsync
		my $rmvreachable = ($p->ping("$rmvhub"));
		undef($p);
		my $reachable = "RMV-Hub is reachable";
		$reachable = "RMV-Hub is NOT reachable!" if not $rmvreachable;
	}

	my $ip1 = $unit->{lan1}->{ip};
	my $ip2 = $unit->{lan2}->{ip};
	my $ip3 = $unit->{lan3}->{ip};
	my $interface_quantity = $unit->{interface_quantity};
	$ip2 = "(not present)" if ($interface_quantity <2);
	$ip3 = "(not present)" if ($interface_quantity <3);
	# 123.123.123.123/24
	# 123456789012345678
	$ip1 = sprintf("%-18s", $ip1);
	$ip2 = sprintf("%-18s", $ip2);
	$ip3 = sprintf("%-18s", $ip3);

	my $rmvserial_msg = "";
	my $gw_msg = "";

	# find GW
	my $gw  = '';
	my $lan = 0;
	for (my $l=1; $l<=$interface_quantity; $l++) {
		my $ip = $unit->{"lan$l"}->{routes}->{'0.0.0.0/0'};
		if ($ip) {
			$gw = $ip;
			$lan=$l;
			last;
		}
	}
	$gw = "<undefined>" if (!$lan);
	my $dev = 'eth' . ($lan-1);

	my $gw_msg = '(WARNING: outside all subnets)';
	if ($lan>0) {
		$gw_msg = "(UNREACHABLE via LAN$lan)";
		my $mac = 0;
		&Net::ARP::arp_lookup($dev,$gw,$mac);
		if ($mac !~ /unknown/i) {
			$gw_msg = "(OK: $mac via LAN$lan)";
		}
	}
	
	my $time_msg = "";
	my $vpn_msg = "";
	my $lan1_msg = "";
	my $lan2_msg = "";
	my $lan3_msg = "";

	my $length_indicator = <<EOT;
0        1         2         3         4         5         6         7         8
12345678901234567890123456789012345678901234567890123456789012345678901234567890
EOT

	print <<EOT;
===============================================================================
RMV-Unit Configuration Menu ($version)     [local time: $ltime]
===============================================================================
 1) Edit LAN1 IP/Netmask   [ $ip1 ] $lan1_msg
 2) Edit LAN2 IP/Netmask   [ $ip2 ] $lan2_msg
 3) Edit LAN3 IP/Netmask   [ $ip3 ] $lan3_msg
 4) Edit Default Gateway   [ $gw ] $gw_msg
 5) Edit RMV Serial Number [ $rmvserial ] $rmvserial_msg
 6) Edit Customer Name     [ $unit->{customer} ]
 7) Edit Hostname          [ rmvu$rmvserial-$unit->{hostname}.rmv.vpn ]

 N) Enter submenu NTP/Time $time_msg
 V) Enter submenu VPN      $vpn_msg
 R) Enter submenu Routes
 A) Apply Settings         $apply_msg
 T) Test Network Settings
 P) Ping

 REBOOT    : Reboot unit
 SHUTDOWN  : Shutdown unit (power-down)
 EXIT/QUIT : Exit menu
===============================================================================
EOT
}

sub run_1 {
	my $o = shift;
	$o->editlan("1");
}

sub run_2 {
	my $o = shift;

	if ($interface_quantity <2) {
		print "<ERROR> This interface is not present\n";
		return;
	}
	$o->editlan("2");
}

sub run_3 {
	my $o = shift;
	if ($interface_quantity <3) {
		print "<ERROR> This interface is not present\n";
		return;
	}
	$o->editlan("3");
}

sub editlan {
	my $o = shift;
	my $n = shift || die;

	my $unit = $o->readconfig();

	my $lan = $unit->{"lan$n"}->{ip};
	
	print <<EOT;
	
Current IP/NETMASK is: $lan
Please enter a new IP/NETMASK or press [ENTER] to keep the current.
You can enter it as a 'dotted-quad',  e.g. 10.3.0.20/255.255.0.0
Or you can enter it in CIDR-notation, e.g. 10.3.0.20/16

EOT
	my $newlan = $o->prompt('IP/NETMASK: ', $lan, undef);

	if ($newlan =~ /^\s*$/i) {
		return;
	}

	if ($newlan eq $lan) {
		print "<WARNING> This settings did not change.\n";
		return;
	}

	print "\n";
	use NetAddr::IP;
	my $naip = NetAddr::IP->new( $newlan ) ;
	if (not $naip) {
		print "<ERROR> Invalid IP/NETMASK !!\n";
	} else {
		my $newlanformat = $naip->cidr();
		print "<OK>\n";
		
		$unit->{"lan$n"}->{ip} = $newlanformat;
		
		$unit->{needapply} = 1;
		$o->writeconfig($unit);
	}
}

sub run_4 {
	# Edit Default Gateway
	my $o = shift;

	my $unit = $o->readconfig();
	
	# find GW
	my $gw  = '';
	my $lan = 0;
	for (my $l=1; $l<=$interface_quantity; $l++) {
		my $ip = $unit->{"lan$l"}->{routes}->{'0.0.0.0/0'};
		if ($ip) {
			$gw = $ip;
			$lan=$l;
			last;
		}
	}
	$gw = "<undefined>" if (!$lan);
	my $dev = 'eth' . ($lan-1);

	print <<EOT;
	
Current GATEWAY is: $gw
Please enter a new GATEWAY or press [ENTER] to keep the current.
The GATEWAY must be inside the subnet of LAN1 or LAN2.

EOT
	my $newgw = $o->prompt('GATEWAY: ', $gw, undef);

	if ($newgw =~ /^\s*$/i) {
		return;
	}

	if ($newgw eq $gw) {
		print "<WARNING> This settings did not change.\n";
		return;
	}

	print "\n";
	use NetAddr::IP;
	my $naip_lan1 = NetAddr::IP->new( $unit->{lan1}->{ip} );
	my $naip_lan2 = NetAddr::IP->new( $unit->{lan2}->{ip} );
	my $naip_lan3 = NetAddr::IP->new( $unit->{lan2}->{ip} );
	my $naip_gw   = NetAddr::IP->new( $newgw );
	my $lan = 0;
	$lan = 1 if $naip_lan1->contains($naip_gw);
	$lan = 2 if $naip_lan2->contains($naip_gw);
	$lan = 3 if $naip_lan3->contains($naip_gw);
	my $notlan = ($lan==1?2:1);
	
	if (not $lan) {
		print "<ERROR> GATEWAY is NOT inside the subnets of LAN1/2/3 !!\n";
	} else {
		print "<OK> GATEWAY is inside LAN$lan\n";

		for (my $l=1; $l<=$interface_quantity; $l++) {
			delete $unit->{"lan$l"}->{routes}->{'0.0.0.0/0'};
		}
		$unit->{"lan$lan"}->{routes}->{'0.0.0.0/0'} = $newgw;
			
		$unit->{needapply} = 1;
		$o->writeconfig($unit);
	}
}

sub run_5 {
	# RMVu Serial Number
	my $o = shift;
	my $unit = $o->readconfig();
	my $rmvserial = sprintf("%03d", $unit->{rmvserial} );

	print <<EOT;
	
Current RMVu-serial is: $rmvserial
Please enter a new RMVu-serial or press [ENTER] to keep the current.
Valid numbers: 1-63

EOT
	my $newrmvserial = $o->prompt('RMVu-serial: ', $rmvserial, undef);

	if ($newrmvserial =~ /^\s*$/i) {
		return;
	}

	$newrmvserial = sprintf("%03d", $newrmvserial);
	
	if ($newrmvserial ne $rmvserial) {
		if ( ($newrmvserial !~ /^\d+$/) or ($newrmvserial<0) or ($newrmvserial>63) ) {
			print "<ERROR> Invalid RMVu-serial !!\n";
			return;
		} else {
			print "<OK>\n";
			$unit->{rmvserial} = sprintf("%03d", $newrmvserial);

			$unit->{needapply} = 1;
			$o->writeconfig($unit);
		}
	}

	my $oldserial = $rmvserial;
	$rmvserial = sprintf("%03d", $unit->{rmvserial} );

	my $gotcert = (-f "/etc/openvpn/rmv_hub1/rmvu$rmvserial.vpncert.rmv2.crt");
	if ($gotcert) {
		print "The VPN-Certificates for RMVu-$rmvserial are present.\n";
	} else {
		print "The VPN-Certificates for RMVu-$rmvserial are NOT PRESENT on this unit!\n";
		print "\n";

		use Net::Ping;
		my $p = Net::Ping->new("tcp", 1);
		$p->{port_num} = 873; # rsync
		my $rmvreachable = ($p->ping("$rmvhub"));
		undef($p);
		if (not $rmvreachable) {
			print "The RMV-Hub is not reachable!\n";
			print "First restore the connection (maybe use RMV-Serial '000') and then return here.\n"
		} else {
			
			my $rmvu_cname = qx"/usr/bin/wget --timeout=5 -qO- http://2.1.0.1/certs-publish/rmvu$rmvserial.vpncert.rmv2.txt";
			chomp $rmvu_cname;
			if (not $rmvu_cname) {
				print "<ERROR> RMVu-$rmvserial does not exist on RMV-Hub!\n";
				return;
			}

			print "Fetching Customer-Name from the RMV-Hub...\n";
			print "Customer-Name: $rmvu_cname\n";
			print "\n";
			print "Please make sure this is the correct serial number\n";
			print "(duplicates will cause network problems!)\n";
			my $sure = $o->prompt('Are you sure? (Y/N): ', 'n', undef);
			if ($sure !~ /y/i) {
				return;
			}

			print "Fetching VPN-Certificates for RMVu-$rmvserial ...\n";
			qx"sudo /rmv/bin/getcerts.pl &>/dev/null";
			$gotcert = (-f "/etc/openvpn/rmv_hub1/rmvu$rmvserial.vpncert.rmv2.crt");
			if ($gotcert) {
				print "<OK> Done!\n";
			} else {
				print "<ERROR> Could not fetch VPN certificates!\n";
			}
		}
	} 

	if ($oldserial ne $rmvserial) {
		qx"sudo /rmv/bin/rmcert.sh rmvu$oldserial.vpncert.rmv2";
	}
}

sub run_6 {
	# Customer Name
	my $o = shift;
	my $unit = $o->readconfig();
	my $customer = $unit->{customer};
	print <<EOT;
	
Current Customer Name is: $customer
Please enter a new Customer Name or press [ENTER] to keep the current.
Max 20 characters.

EOT
	my $newcustomer = $o->prompt('Customer: ', $customer, undef);

	if ($newcustomer =~ /^\s*$/i) {
		return;
	}

	if ($newcustomer eq $customer) {
		print "<WARNING> This settings did not change.\n";
	}

	if (length($newcustomer) > 20) {
		print "<ERROR> Customer Name to long !!\n";
	} else {
		print "<OK>\n";
		$unit->{customer} = $newcustomer;

		$unit->{needapply} = 1;
		$o->writeconfig($unit);
	}
}

sub run_7 {
	# Unit Hostname
	my $o = shift;

	my $unit = $o->readconfig();
	my $hostname = $unit->{hostname};
	print <<EOT;
	
Current Hostnameis: $hostname
Please enter a new Hostname or press [ENTER] to keep the current.
Max 20 characters.

EOT
	my $newhostname = $o->prompt('Hostname: ', $hostname, undef);

	if ($newhostname =~ /^\s*$/i) {
		return;
	}

	if ($newhostname eq $hostname) {
		print "<WARNING> This settings did not change.\n";
	}

	if (length($newhostname) > 20) {
		print "<ERROR> Hostname to long !!\n";
	} else {
		print "<OK>\n";
		$unit->{hostname} = $newhostname;

		$unit->{needapply} = 1;
		$o->writeconfig($unit);
	}
}

sub run_n {
	my $o = shift;
	# Routes

	print "(not yet implemented)\n";
}

sub run_v {
	my $o = shift;
	# VPN

	print "(not yet implemented)\n";
}

sub run_r {
	my $o = shift;
	# Routes 

	print "(not yet implemented)\n";
}

sub run_a {
	my $o = shift;
	# Apply Settings

	print <<EOT;

This will apply the Network Settings.
Please note that if you changed the IP address you may loose connection!

EOT
	my $sure = $o->prompt('Are you sure? (Y/N): ', 'n', undef);
	if ($sure =~ /y/i) {
		print "Applying...\n";

		#qx"sudo /rmv/bin/apply_unitdat.pl &>/dev/null";
		&RMV::Config::apply_files();

		if (! open(FH, "sudo /rmv/bin/restartnetwork.sh 2>&1 |")) { die "Can't spawn external command!"; }
		while (defined (my $line = <FH>)) { print $line;}
		if (!close(FH)) { die "External command failed: $?";}

		print <<EOT;
Done!

You can directly test the Network Setup.
Please note: It can take up to 1 minute for a new VPN tunnel
             is setup to the RMV-Hub.
Please note: after succesfull setup/test you need a reboot.
EOT
	}

	print "\n";
}

sub run_t {
	my $o = shift;
	# Test Network Settings

	print "\nStarting Network Test...\n";

	if (! open(FH, "sudo /rmv/bin/networktest.pl 2>&1 |")) { die "Can't spawn external command!"; }
	while (defined (my $line = <FH>)) { print $line;}
	#if (!close(FH)) { die "External command failed: $?";}
	close(FH);
	
	print "\n";
	#my $sure = $o->prompt('Press ENTER to continue', 'n', undef);
}

sub run_p {
	my $o = shift;
	# Goto Ping submenu

	print "\n";
	my $pingip = $o->prompt('Enter an IP address: ', '', undef);

	if ($pingip !~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/) {
		print "\n<ERROR> Not a valid IP address !!\n";
	} else {
		
		if (! open(FH, "sudo /rmv/bin/pingip.sh $pingip 2>&1 |")) { die "Can't spawn external command!"; }
		while (defined (my $line = <FH>)) { print $line;}
		#if (!close(FH)) { die "External command failed: $?";}
		close(FH);

		print "\n";

	}
}

sub run_reboot {
	my $o = shift;

	print <<EOT;

This will REBOOT the unit !!!

EOT
	my $sure = $o->prompt('Are you sure? (Y/N): ', 'n', undef);
	if ($sure =~ /y/i) {
		qx"sudo /usr/local/bin/doreboot";
	}
}

sub run_shutdown {
	my $o = shift;

	print <<EOT;

This will SHUTDOWN the unit !!!

EOT
	my $sure = $o->prompt('Are you sure? (Y/N): ', 'n', undef);
	if ($sure =~ /y/i) {
		qx"sudo /usr/local/bin/doshutdown";
	}
}

sub run_exit {
	ReadMode 'normal';
	exit;
}
sub alias_exit { qw(q quit) }

sub run_changeiq {
	# Change Interface Quantity
	my $o = shift;

	my $unit = $o->readconfig();
	$interface_quantity = $unit->{interface_quantity};
	print <<EOT;
	
Current Interface Quantity is: $interface_quantity
Please enter a new quantitity or press [ENTER] to keep the current.
Valid number: 1..3

EOT
	my $newiq = $o->prompt('Interface quantity: ', $interface_quantity, undef);

	if ($newiq =~ /^\s*$/i) {
		return;
	}

	if ($newiq eq $interface_quantity) {
		print "<WARNING> This settings did not change.\n";
	}

	if ($newiq !~ /^\d+/) {
		print "<ERROR> not a number !\n";
	} elsif (($newiq<1) or ($newiq>3)) {
		print "<ERROR> outside range 1..3 !\n";
	} else {
		print "<OK>\n";
		$unit->{interface_quantity} = $newiq;

		$o->writeconfig($unit);
	}
}


package main;

#use Data::Dumper;
use Term::ReadKey;

# disabled - pwd via PAM (serial-tty/telnet/ssh)
if (0) {
	my $config_pwd = 'rmvconfig78';
	my $tty = qx"tty";
	my $networktty = ($tty =~ /pts/);
	if ($networktty) { 
		ReadMode 'noecho';
		my $pwd = '';
		do { 
			print "Password (or ENTER to quit): "; 
			$pwd = <STDIN>;
			chomp $pwd;
			print "\n";
			if (!$pwd) {
				ReadMode 'normal';
				exit;
			}
			if ($pwd ne $config_pwd) {
				print "Invalid password... \n";
				sleep 1;
			}
		} until ( !$pwd or $pwd eq $config_pwd);
		ReadMode 'normal';
	}
}
'rmvconfigshell'->new('default')->cmdloop;

