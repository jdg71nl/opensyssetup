#!/usr/bin/perl
use Cisco::ACL;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;

# ------+++------
# convert lines to structs:
#
my $expansions = {};
my $acls = {};
my $context = '';
my $line_nr = 0;
my $re_exp_names = 'notamatchwithanyname';

while (my $line = <>) {

	#chomp ($line);
	# better that chomp:
	$line =~ s/\s*$//g; 

	$ori_line = $line;
	$line_nr++;

	#print "--- $line \n";

	# remove comment at end of lines:
	$line =~ s/^(.*?)[!#;].*$/$1/;
	# replace any multi-whitespace with one space:
	$line =~ s/\s+/ /g;
	# remove any starting or trailing whitespace:
	$line =~ s/^\s*(\S.*?)\s*$/$1/;

	#print "--- $line \n";

	# ingore empty lines:
	next if ($line =~ /^$/);

	# start of ACL:
	if ($line =~ /^pacl\s+([\w\-_]+)/i) {
		$new_acl	= $1;
		$acls->{$new_acl} = {vlan => 0, subnet => '0.0.0.0/0', gateway => '0.0.0.0', acl => [] };
		$context = $new_acl;
		next;
	}

	# define VLAN nr:
	if ($line =~ /^vlan\s+(\d+)/i) {
		my $vlan = $1;
		$vlan += 0;
		$acls->{"$context"}->{vlan} = $vlan;
		next;
	}

	# define local subnet:
	if ($line =~ /^subnet\s+([\d\.\/]+)/i) {
		my $subnet = $1;
		$acls->{"$context"}->{subnet} = $subnet;
		next;
	}

	# define local gateway:
	if ($line =~ /^gateway\s+([\d\.]+)/i) {
		my $gateway = $1;
		$acls->{"$context"}->{gateway} = $gateway;
		next;
	}

	# insert ACL line:
	if ($line =~ /^insert ([\w\-_]+)/) {
		$templ_acl = $1;
		push @{ $acls->{"$context"}->{acl} }, @{ $acls->{"$templ_acl"}->{acl} };
		next;
	}

	# everything else is lowercase:
	$line = lc $line;

	# replace 'any' with 0.0.0.0/0 but only if not part of alias-name"
	#$line =~ s/(?<=\s|,)any(?=\s|,|$)/0.0.0.0\/0/g;

	# ACL line:
	if ($line =~ /^(permit|deny)\s+/) {
		push @{ $acls->{"$context"}->{acl} }, $line;
		next;
	}

	# literal ACL line:
	if ($line =~ /^literal (permit|deny)\s+/) {
		push @{ $acls->{"$context"}->{acl} }, $line;
		next;
	}

	# ACL line:
	if ($line =~ /^(permit|deny)\s+/) {
		push @{ $acls->{"$context"}->{acl} }, $line;
		next;
	}

	# alias:
	if ($line =~ /^([a-z][\w\-_]+):\s+([\w\-_,\.\/]+)$/) {
		$source	= $1;
		$dest		= $2;

		if ( $source =~ /($re_exp_names)/ ) {
			my $conflict = $1;
			print "! [ERROR] alias '$source' matches with the already defined alias '$conflict'\n";
			exit;
		}

		$expansions->{$source} = $dest;

		# built new:
		$re_exp_names = join '|', keys %{ $expansions };
		#print "re_exp_names=$re_exp_names\n";

		next;
	}

	# else:
	print "! [ERROR] Line has unknown format. line-nr: $line_nr, line: '$ori_line'\n";

}
#print "\$expansions = ". Dumper(\$expansions) . "\n" . "\$acls = ". Dumper(\$acls); 
#exit;

# ------+++------
# print each ACL
#
foreach $name ( sort keys %{ $acls } ) {
	my $acl_struct = $acls->{$name};

	my $vlan = $acl_struct->{vlan} || 0;
	next if ! $vlan ;

	print "! ------+++------ \n";
	print "interface Vlan". $acl_struct->{vlan} ."\n";
	print " no ip access-group $name in\n";
	print "!\n";
	print "no ip access-list extended $name\n";
	print "ip access-list extended $name\n";

	foreach my $a (@{ $acl_struct->{acl} }) {

		if ($a =~ /^literal\s+(.*)$/) {
			$a = $1;
			print " $a\n";
			next;
		}

		$a =~ /^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s*(\S*)$/;
		my $action	= $1;
		my $prot		= $2;
		my $source	= $3;
		my $dest		= $4;
		my $dport	= $5 || '';

		# allow for late definition of ACL expansions:
		my $subnet = $acl_struct->{subnet} || '0.0.0.0/0';
		$expansions->{"subnet"} = $subnet;
		my $gateway = $acl_struct->{gateway} || '0.0.0.0';
		$expansions->{"gateway"} = $gateway;

		$re_exp_names = join '|', keys %{ $expansions };
		#print "\$expansions = ". Dumper(\$expansions) . "\n" . "\$acls = ". Dumper(\$acls); exit;

		# expand strings
		&expand(\$source);
		&expand(\$dest);
		&expand(\$dport);
		#print "source=$source dest=$dest dport=$dport \n";

		# change string-list to lists
		@source_list	= split(/,/, $source);
		@dest_list		= split(/,/, $dest);
		@dport_list		= split(/,/, $dport);
		my $acl = Cisco::ACL->new(
			permit => ($action eq 'permit'?1:0),
			protocol => $prot,
			src_addr => \@source_list,
			dst_addr => \@dest_list,
			dst_port => \@dport_list,
		);
		print " $_\n" for( $acl->acls );

	} # foreach acl-line

	print "!\n";
	print "interface Vlan". $acl_struct->{vlan} ."\n";
	print " ip access-group $name in\n";
	print "!\n";
	print "\n";
}
print "! ------+++------ \n";

sub expand {
	my $line_ref = shift || die;
	#print "sub expand: line='".$$line_ref."'\n";

	# search for any word, then expand it:
	my $count = 0;

	#while ( $$line_ref =~ /(?<=\s|,)($re_exp_names)(?=\s|,|$)/ ) {
	while ( $$line_ref =~ /($re_exp_names)/ ) {

		my $name = $1 || die "! expand: no name found";

		if ($count++ > 99) {
			#prin "! [ERROR] unknown keyword '$name' in line '$$line_ref'\n";
			print "! [ERROR] count reached in expand() \n";
			last;
		}

		my $expansion = $expansions->{$name} || next;
		$$line_ref =~ s/$name/$expansion/;
	}
}

__DATA__

# example of input:
> cat recursive-pseudo-ACL-compiler.pl | egrep -A500 '^# Pseudo-ACL' | expand -t3 - > voorbeeld-pseudoacl.txt 

# Pseudo-ACL file <Recursive ACL Compiler>
#
# File Format:
# - define aliases
# - define ACLs
#
# File Description:
# - all lines starting with [#|!|;] or a space/tab is ignored as a comment-line
# - multiple whitespaces (space, commas) are allowed and converted to a single space
# - comments at the end of a line after [#|!|;] are allowed (and removed before processing)
#
# Alias Format:
# aliasname: element1,element2,element3
#
# Alias Description:
# - aliases can contain these characters: [a-z0-9-_] but must always start with [a-z]
# - aliases can be used for hosts, networks and/or services 
# - aliases are case-insensitive, comma-seperated, no spaces between elements, can be used recursively
#
# Examples:
#
# ACL Format (start with nr/name, then lines with ACLs):
# vlan-nr:ACL-name:
# permit|deny protocol(ip|tcp|udp|icmp) source-address(es) destination-address(es) destinaton-port(s)
#
# ACL Description:
# - ACL-name can contain these characters: [a-zA-Z0-9-_]
# - hosts/networks can be specified with a slash (IP/29) or range (IP.4-7) notation
# - subnet-notation(shlash) is automatically converted to wildcard-notation
# - ports can be specified with a range (5900-5909) notation
# - hosts/networks/ports can have multiple elements seperated with comma (no spaces!)
# - hosts/networks can be identified with keyword any (=0.0.0.0/0) which is a standard keyword in Cisco-ACLs
# - any ACL line starting with keyword 'literal' is copied as-is (to allow for other formats, e.g. source ports in ACLs)
# - an ACL line starting with keyword 'insert ACL-name' will copy the ACL-lines of ACL 'ACL-name' into the current ACL
#
# Example
dmz:						172.16.99.0/25
servers: 				dmz,80.12.34.8-12
clients: 				10.0.8.0/24
web: 						80,443
proxy: 					web,8080
vnc-any: 				5900-5909
pacl ACL-generic
	permit	tcp	subnet						gateway					https			! allow https to gateway
	deny		ip		subnet						gateway
	permit	udp	any							224.0.0.2				1985			! allow HSRP
pacl ACL-v71-in
	vlan 71
	subnet	10.0.71.0/24
	gateway	10.0.71.254
	insert	ACL-generic
	literal	permit udp any eq 53 host 192.168.45.23 eq 53						! use literal ACL lines e.g. to define source-ports
	permit	tcp	clients 						servers 					proxy
	deny		tcp	subnet						any						vnc-any
#
pacl ACL-v72-in
	vlan		72
	subnet	10.0.72.0/24
	gateway	10.0.72.254
	insert	ACL-generic
	deny		udp	clients,172.16.9.0/24	10.8.1.1-24				69,90-94
#
#/Example

