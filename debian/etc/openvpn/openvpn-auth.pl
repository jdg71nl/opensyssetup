#!/usr/bin/perl

# ---
# use in openvpn config file:
#
# #needed ONLY in 2.1:
# script-security 2
#
# auth-user-pass-verify auth.pl via-file
# client-connect        connect.pl
# client-disconnect     connect.pl
# 
# ---

use strict;
use constant TRUE => 1; # perl: <>0
use constant FALSE => 0;

use File::Basename ;
my $basename = basename($0);

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

my $msg="";

# -----------------------------------------------------------------------------
# Get username/password from file

my $auth_file;
if ($auth_file = shift @ARGV) {
    if (!open (FILE, "<$auth_file")) {
        $msg = "Could not open username/password file: $auth_file ";
		  &syslog_and_die("$basename: $msg");
    }
} else {
    $msg = "No username/password file specified on command line ";
	  &syslog_and_die("$basename: $msg");
}

my $username = <FILE>; # read one line
my $password = <FILE>; # read one line

if (!$username || !$password) {
    $msg = "Username/password not found in file: $auth_file ";
	  &syslog_and_die("$basename: $msg");
}

chomp $username;
chomp $password;

close (FILE);

# -----------------------------------------------------------------------------
# get group

my $commonname = '';
#my $tls_id_0 = $ENV{'tls_id_0'} || '';
#$tls_id_0 =~ /CN=([^\/]*)/;
#my $commonname = $1 || '';
#
#if (!$commonname) {
#	$msg = "No CommonName found in ENV(tls_id_0)";
#	syslog_and_die("$basename: $msg");
#}

# -----------------------------------------------------------------------------
# get source_ip

my $sourceip	= $ENV{'untrusted_ip'} || '';
my $sourceport	= $ENV{'untrusted_port'} || '';
#my $untrusted_host = gethostbyaddr(inet_aton($untrusted_ip), AF_INET) || "";

# -----------------------------------------------------------------------------
# log

$msg = "succesfully received info from openvpn: username=$username, commonname=$commonname, sourceip=$sourceip, sourceport=$sourceport";
&syslog_debug("$basename: $msg");

# -----------------------------------------------------------------------------
# authenticate

$msg = "authentication request for user '$username', from source IP/port: $sourceip/$sourceport with CN='$commonname'.";
&syslog_debug("$basename: $msg");
print "--- $basename (PID:$$): $msg";

my $auth_msg = &authenticate_user ( { 
	username		=> $username,
	password		=> $password, 
	commonname	=> $commonname, 
	sourceip		=> $sourceip, 
	sourceport	=> $sourceport 
} );

if ($auth_msg) {
	&syslog_debug("$basename: $auth_msg");
	print "--- $basename (PID:$$): $auth_msg \n";
	# that means there is an error, so exit 1
	exit 1;
} else {
	$msg = "authentication for user '$username' successfull.";
	&syslog_debug("$basename: $msg");
	print "--- $basename (PID:$$): $msg";
	exit 0; # success
}

sub authenticate_user {
	my $h = shift || {};
	if ( ($h->{username} eq 'jdg') and ($h->{password} eq 'asd234') ) {
		return '';
	} else {
		return 'user unknown';
	}
}

my $logfile = "/var/log/openvpn-fflabs-clserver.log";
sub syslog_and_die {
	my $msg = shift || '';
	&syslog_debug($msg);
	die;
}

sub syslog_debug {
	my $msg = shift || '';
	if (open (FILE, ">>$logfile")) {
		print FILE "$msg\n";
		close FILE;
	}
}

__DATA__

cat /tmp/auth.pl.env.txt
{
  'CONSOLE' => '/dev/console',
  'HOME' => '/',
  'INIT_VERSION' => 'sysvinit-2.85',
  'LANG' => 'en_US.UTF-8',
  'PATH' => '/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin',
  'PREVLEVEL' => 'N',
  'PWD' => '/etc/openvpn/sbc_cl',
  'RUNLEVEL' => '3',
  'SELINUX_INIT' => 'YES',
  'SHLVL' => '3',
  'TERM' => 'linux',
  '_' => '/etc/openvpn/scripts/auth.pl',
  'bytes_received' => '',
  'bytes_sent' => '',
  'common_name' => 'group1.client.vpncert.sbc',
  'config' => 'sbc_cl.conf',
  'daemon' => '1',
  'daemon_log_redirect' => '1',
  'dev' => 'tun11',
  'ifconfig_local' => '172.28.1.1',
  'ifconfig_pool_local_ip' => '',
  'ifconfig_pool_remote_ip' => '',
  'ifconfig_remote' => '172.28.1.2',
  'link_mtu' => '1542',
  'local_port' => '28001',
  'previous' => 'N',
  'proto' => 'udp',
  'route_gateway_1' => '172.28.1.2',
  'route_gateway_2' => '172.28.1.2',
  'route_gateway_3' => '172.28.1.2',
  'route_net_gateway' => '80.69.65.1',
  'route_netmask_1' => '255.255.255.0',
  'route_netmask_2' => '255.255.255.0',
  'route_netmask_3' => '255.255.255.248',
  'route_network_1' => '172.28.1.0',
  'route_network_2' => '172.24.6.0',
  'route_network_3' => '172.28.1.0',
  'route_vpn_gateway' => '172.28.1.2',
  'runlevel' => '3',
  'script_context' => 'init',
  'script_type' => 'user-pass-verify',
  'tls_id_0' => '/C=NL/ST=ZH/O=SmallBizConcepts_BV/CN=group1.client.vpncert.sbc/emailAddress=certs@smallbizconcepts.nl',
  'tls_id_1' => '/C=NL/ST=ZH/L=DELFT/O=SmallBizConcepts_BV/CN=ca.vpncert.sbc/emailAddress=certs@smallbizconcepts.nl',
  'tls_serial_0' => '16',
  'tls_serial_1' => '0',
  'trusted_ip' => '',
  'trusted_port' => '',
  'tun_mtu' => '1500',
  'untrusted_ip' => '82.204.33.202',
  'untrusted_port' => '4711',
  'verb' => '4',
  'vga' => '773'
}

