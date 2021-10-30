#!/usr/bin/perl

# example use:
# find . -type f -name "[1-9]*" -size +1 -exec /usr/local/syssetup/bin/print_rancid_hostname_model_serial.pl "{}" \;
# find . -type f -name "[1-9]*" -size +1 -exec /usr/local/syssetup/bin/print_rancid_hostname_model_serial.pl "{}" \; | sort -k10
# find . -type f -name "[1-9]*" -size +1 -exec /usr/local/syssetup/bin/print_rancid_hostname_model_serial.pl "{}" \; | sort -k10 | uniq --skip-fields=9 --all-repeated

my $nrARGS = $#ARGV + 1 ;     # Note: $#ARGV hold # of arguments minus 1 (so nothing is "-1")
if ($nrARGS<1) {
	print "\n";
	print "# use this script with find, e.g.:\n";
	print 'find . -type f -name "[1-9]*" -size +1 -exec /usr/local/syssetup/bin/print_rancid_hostname_model_serial.pl "{}" \;';
	print "\n";
	print "\n";
	exit;
}


use File::Basename ;
use Cwd 'abs_path';
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = TRUE;
$Data::Dumper::Terse = TRUE;

my $file = shift @ARGV || die "no argument (file) given!";
my $ip = basename(abs_path($file)) ; # only name, abs_path resolves symlinks

# V1:
#open(FILE,"<$file");
#my @lines	= <FILE>;
#close FILE;

open my $fh, '<', $file or die "error opening $file: $!";
my $text = do { local $/; <$fh> };

# ------+++------
### Cisco switch:
# !Motherboard serial number       : FCQ155107KA
# !Model number                    : WS-C3750X-48T-L
# hostname c3560-Eckertdal

### Cisco switch stack (3750x)
# !NAME: "Cat37xx Stacking",      DESCR: "Catalyst 37xx Switch Stack"
# !NAME: "1",                     DESCR: "WS-C3750X-48"
# !PID: WS-C3750X-48T-L
# !VID: V02
# !SN: FDO1512R1DG
# !NAME: "2",                     DESCR: "WS-C3750X-48"
# !PID: WS-C3750X-48T-L
# !VID: V02
# !SN: FDO1512Z1H7
# !NAME: "3",                     DESCR: "WS-C3750X-48"
# !PID: WS-C3750X-48T-L
# !VID: V02
# !SN: FDO1512R1F0

### Cisco router
# !Processor ID: GMK1224002Z
# !Image: Software: C860VAE-IPBASEK9-M, 15.1(4)M4, RELEASE SOFTWARE (fc1)
# !PID: CISCO867VAE
## or
# !Chassis type: 2621XM - a 2600 router!Chassis type: 2621XM - a 2600 router
# hostname WDD-GBS-C30010

### Juniper
# # Hostname: LNDW-C013
# # Model: srx210be
# # JUNOS Software Release [10.4R4.5]
## or:
# # KERNEL 11.4R5.5 #0 built by builder on 2012-08-25 08:35:54 UTC# KERNEL 11.4R5.5 #0 built by builder on 2012-08-25 08:35:54 UTC
# # Chassis                                BK3711AA0034      SRX210be
# set system host-name LNDW-C013

### HP
# ;Chassis type: J4899B
# ;Serial Number: TW546SD06Q
# ;Image: H.08.67
# hostname "ALPA-C114" 

### Netscreen-Juniper-SSG
# #Product: SSG5-Serial
# #SN: 0162072010000470
# #HW: 0710(0)-(00)
# #Netscreen Type: Firewall+VPN
# #Software Version: 6.3.0r6.0
# set hostname FW-IJsselland_FW01
# ------+++------

# v1:
#my @seriallines		= grep /^!Motherboard serial number/i,	@lines;
#my @modellines  	= grep /^!Model number/i,		@lines;
#my @hostnamelines	= grep /^hostname/,			@lines;
#my $hostname	= $hostnamelines[0]	|| '?';
#chomp($hostname);
#$hostname	=~ s/^hostname\s+(\S+).*$/$1/;
#my $i = 0;
#foreach my $serial (@seriallines) {
#	
#	chomp($serial);
#
#	my $model	= $modellines[$i]	|| '?';
#	chomp($model);
#
#	$serial 	=~ s/^!Motherboard serial number\s+:\s+(\S+).*$/$1/;
#	$model		=~ s/^!Model number\s+:\s+(\S+).*$/$1/;
#
#	print "$ip\t$serial\t$model\t$hostname\n";
#	$i++;
#}

my @seriallines	= ();
my @modellines  	= ();
my @hostnamelines	= ();
my @versionlines	= ();
my $serial			= "";
my $model			= "";
my $hostname		= "";
my $version			= "";

#@seriallines	= grep /^!SN: /i,								@lines;
#@modellines  	= grep /^!PID: /i,							@lines;
#@hostnamelines	= grep /^hostname /,							@lines;
#@versionlines	= grep /^!Image: Software:/i,				@lines;
#$serial			= $seriallines[0]		|| '';
#$model			= $modellines[0]		|| '';
#$hostname		= $hostnamelines[0]	|| '';
#$version			= $versionlines[0]	|| '';

# Cisco switch
if (!$serial)   { $text 	=~ /^!Motherboard serial number\s*:\s*(\w+)/m;	$serial 		= $1 || ''; }
if (!$model)    { $text 	=~ /^!Model number\s*:\s*([\w\-]+)/m;				$model  		= $1 || ''; }
if (!$hostname) { $text 	=~ /^hostname ([\w\-\_]+)/m;							$hostname	= $1 || ''; }
if (!$version)  { $text 	=~ /^!Image.*Software.*?(1[125]\.[\w\d\(\)]*)/m;	$version		= $1 || ''; }
# Cisco router
if (!$serial)   { $text 	=~ /^!Processor ID\s*:\s*(\w+)/m; 					$serial 		= $1 || ''; }
if (!$model)    { $text 	=~ /^!PID\s*:\s*([\w\-]+)/m;							$model  		= $1 || ''; }
if (!$model)    { $text 	=~ /^!Chassis type:\s*([\w\-]+)/m;					$model  		= $1 || ''; }
# Juniper Junos
if (!$serial)   { $text 	=~ /^# Chassis\s*(\w+)/m; 								$serial 		= $1 || ''; }
if (!$model)    { $text 	=~ /^# Model:\s*([\w\-]+)/m;							$model  		= $1 || ''; }
if (!$hostname) { $text 	=~ /^set system host-name\s+([\w\-\_]+)/m;		$hostname	= $1 || ''; }
if (!$version)  { $text 	=~ /^# JUNOS Software Release \[([\w\d\(\)\-\.]*)\]/m;	$version		= $1 || ''; }
if (!$version)  { $text 	=~ /^# KERNEL ([\w\d\(\)\-\.]*)/m;	$				version		= $1 || ''; }
# HP
if (!$serial)   { $text 	=~ /^;Serial Number:\s*(\w+)/m; 						$serial 		= $1 || ''; }
if (!$model)    { $text 	=~ /^;Chassis type:\s*([\w\-]+)/m;					$model  		= $1 || ''; }
if (!$hostname) { $text 	=~ /^hostname "([\w\-\_]+)"/m;						$hostname	= $1 || ''; }
if (!$version)  { $text 	=~ /^;Image: ([A-Z]\.[\w\d\(\)\-\.]*)/m;				$version		= $1 || ''; }
# Netscreen / Juniper SSG
if (!$serial)   { $text 	=~ /^#SN:\s*(\w+)/m; 									$serial 		= $1 || ''; }
if (!$model)    { $text 	=~ /^#Product:\s*([\w\-]+)/m;							$model  		= $1 || ''; }
if (!$hostname) { $text 	=~ /^set hostname ([\w\-\_]+)/m;						$hostname	= $1 || ''; }
if (!$version)  { $text 	=~ /^#Software Version: ([\w\d\(\)\-\.]*)/m;		$version		= $1 || ''; }

if ($text =~ /DESCR: ".*Switch Stack/m) {

# !NAME: "Cat37xx Stacking",      DESCR: "Catalyst 37xx Switch Stack"
# !NAME: "1",                     DESCR: "WS-C3750X-48"
# !PID: WS-C3750X-48T-L
# !VID: V02
# !SN: FDO1512R1DG

	for (my $i = 1; $i < 9; $i++) {
		$text =~ /!NAME: "$i",\s*DESCR:.*\n!PID: ([\w\-]+).*\n!VID.*\n!SN: (\w+)/m;
		$model  = $1 || '';
		$serial = $2 || '';
		if ($serial) {
			printf ("IP:\t%-15s\tHostname:\t%-24s\tModel:\t%-20s\tVersion:\t%-20s\tSerial:\t%-15s\n", $ip,$hostname,$model,$version,$serial);
		}
	}

} else {
	
	#print "IP:$ip\tHostname:$hostname\tModel:$model\tVersion:$version\tSerial:$serial\n";
	#printf ("%-15s\tHostname:%-24s\tModel:%-20s\tVersion:%-20s\tSerial:%-15s\n", $ip,$hostname,$model,$version,$serial);
	#printf ("%-15s\t%-24s\t%-20s\t%-20s\t%-15s\n", $ip,$hostname,$model,$version,$serial);
	printf ("IP:\t%-15s\tHostname:\t%-24s\tModel:\t%-20s\tVersion:\t%-20s\tSerial:\t%-15s\n", $ip,$hostname,$model,$version,$serial);

}

