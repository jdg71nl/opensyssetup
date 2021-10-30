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

my $msg = "";

# -----------------------------------------------------------------------------
#testing: write ENV to file

if (0 && open (ENVFILE, ">/tmp/$basename.env.txt")) {
	print ENVFILE Dumper(\%ENV);
	csdlose ENVFILE;
}

my $script_type = $ENV{'script_type'} || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: ENV:script_type was not provided");

# -----------------------------------------------------------------------------
# import user

my $user_loginname_s = $ENV{'common_name'} || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: ENV:common_name was not provided");

# -----------------------------------------------------------------------------
# get group

my $tls_id_0 = $ENV{'tls_id_0'} || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: ENV:tls_id_0 was not provided");

$tls_id_0 =~ /CN=([^\/]*)/;
my $cert_cn = $1 || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: cert_cn could not be calculated from tls_id_0");

# -----------------------------------------------------------------------------
# get source

my $user_vpn_source_ip_s 	= $ENV{'trusted_ip'} || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: ENV:trusted_ip was not provided");

my $user_vpn_source_port_n	= $ENV{'trusted_port'} || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: ENV:trusted_port was not provided");

# -----------------------------------------------------------------------------
# log

$msg = "(script_type=$script_type) succesfully received info from openvpn: user_loginname_s=$user_loginname_s, cert_cn=$cert_cn, user_vpn_source_ip_s=$user_vpn_source_ip_s, user_vpn_source_port_n=$user_vpn_source_port_n";
&FlexVPN::DB::syslog_debug("$basename: $msg");

# -----------------------------------------------------------------------------
#	
if ($script_type eq 'client-connect') {

	my $connect_config_file = shift @ARGV || &FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: no ARGV given for config_file");
	if (!open (FILE, ">$connect_config_file")) {
		&FlexVPN::DB::syslog_and_die("--- $basename (PID:$$) ERROR: could not open file '$connect_config_file'");
	}

	$msg = "connect user '$user_loginname_s', group '$cert_cn' from source/port '$user_vpn_source_ip_s/$user_vpn_source_port_n' ";
	&FlexVPN::DB::syslog_debug("$basename: $msg");
	print "--- $basename (PID:$$): $msg\n";


	my $connect_config = &FlexVPN::Openvpn::connect( {
		user_loginname_s			=> $user_loginname_s,
		cert_cn						=> $cert_cn,
		user_vpn_source_ip_s 	=> $user_vpn_source_ip_s,
		user_vpn_source_port_n	=> $user_vpn_source_port_n,
	} );
								
	print FILE "$connect_config\n";
	close (FILE);

	$msg = "connect complete \n";
	&FlexVPN::DB::syslog_debug("$basename: $msg");
	print "--- $basename (PID:$$): $msg\n";

	exit 0; # success
}

if ($script_type eq 'client-disconnect') {

	$msg = "disconnect user '$user_loginname_s', group '$cert_cn' from source/port '$user_vpn_source_ip_s/$user_vpn_source_port_n' ";
	&FlexVPN::DB::syslog_debug("$basename: $msg");
	print "--- $basename (PID:$$): $msg\n";

	my $connect_config = &FlexVPN::Openvpn::disconnect( {
		user_vpn_source_ip_s => $user_vpn_source_ip_s,
	} );

	$msg = "disconnect complete \n";
	&FlexVPN::DB::syslog_debug("$basename: $msg");
	print "--- $basename (PID:$$): $msg\n";

	exit 0; # success
}

# we should never reach this point:
die;
exit 0;

__DATA__

> cat /tmp/connect.pl.env.txt
$VAR1 = {
          'SSH_ASKPASS' => '/usr/libexec/openssh/gnome-ssh-askpass',
          'tls_id_1' => '/C=NL/ST=ZH/L=DELFT/O=SmallBizConcepts_BV/CN=ca.vpncert.rmv2/emailAddress=certs.rmv@smallbizconcepts.nl',
          'daemon_log_redirect' => '1',
          'common_name' => 'jviester',
          'route_netmask_2' => '255.255.255.248',
          'LESSOPEN' => '|/usr/bin/lesspipe.sh %s',
          'verb' => '4',
          'PWD' => '/etc/openvpn/rmv_cl',
          'route_network_2' => '2.1.1.0',
          'bytes_sent' => '',
          'LANG' => 'en_US.UTF-8',
          'route_net_gateway' => '80.69.65.1',
          'USER' => 'root',
          'trusted_port' => '34015',
          'G_BROKEN_FILENAMES' => '1',
          'LOGNAME' => 'root',
          'proto' => 'udp',
          'ifconfig_pool_local_ip' => '2.1.1.5',
          'dev' => 'tun101',
          'SHLVL' => '3',
          'untrusted_ip' => '82.93.46.104',
          'bytes_received' => '',
          'INPUTRC' => '/etc/inputrc',
          'local_port' => '21081',
          'tun_mtu' => '1500',
          'route_network_1' => '2.1.1.0',
          'PATH' => '/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin',
          'route_gateway_1' => '2.1.1.2',
          'link_mtu' => '1542',
          'TERM' => 'xterm',
          'HISTSIZE' => '1000',
          'route_gateway_2' => '2.1.1.2',
          'HOME' => '/root',
          'trusted_ip' => '82.93.46.104',
          'ifconfig_local' => '2.1.1.1',
          'ifconfig_remote' => '2.1.1.2',
          'untrusted_port' => '34015',
          'tls_serial_0' => '11',
          'MAIL' => '/var/spool/mail/root',
          'daemon' => '1',
          'ifconfig_pool_remote_ip' => '2.1.1.6',
          'HOSTNAME' => 'multi-adam-01.smallbizconcepts.nl',
          'route_vpn_gateway' => '2.1.1.2',
          '_' => '/etc/openvpn/rmv_cl/connect.pl',
          'route_netmask_1' => '255.255.255.0',
          'tls_id_0' => '/C=NL/ST=ZH/O=SmallBizConcepts_BV/CN=group1.client.vpncert.rmv2/emailAddress=certs.rmv@smallbizconcepts.nl',
          'LS_COLORS' => 'no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:',
          'SHELL' => '/bin/bash',
          'tls_serial_1' => '0',
          'script_type' => 'client-connect',
          'config' => 'rmv_cl.conf',
          'script_context' => 'init'
        };

