#!/usr/bin/perl -w
use IO::Socket ;
use Socket;
# Send UDP:
my $address = shift;
my $command = shift || die ('ERROR: provide address and message.');
my $cookie = '60C6F00D';
my $msg = "$cookie". uc($command);
printf "%-56s %s\n", "Sending using UDP/9115 to $address CPE-Command:", "$cookie ". uc($command);;
my $bytes = pack( 'H36', $msg);
my $sock = IO::Socket::INET->new(
	PeerAddr => $address,
	PeerPort => 9115,
	LocalPort => 9115,
	Proto =>'udp',
) || die "Cannot connect to udp socket\n" ;
$sock->send($bytes) or die "ERROR send: $!";
close($sock) ;
# Receive UDP:
my $UDPTIMEOUT = 2;
my $udpmaxsize = 1400;
my $recv_sock = IO::Socket::INET->new(
	PeerPort => 9115,
	LocalPort => 9115,
	Proto => 'udp',
) || die "ERROR: could not open UDP socket for reading: $!";
$msg = '';
eval {
    local $SIG{ALRM} = sub { die "alarm time out" };
    alarm $UDPTIMEOUT;
    $recv_sock->recv($msg, $udpmaxsize) or die "recv: $!";
    alarm 0;
    1;  # return value from eval on normalcy
} or die "FAIL: UDP time-out (after $UDPTIMEOUT seconds)\n";
my ($port, $ipaddr) = sockaddr_in($recv_sock->peername);
my $hishost = inet_ntoa($ipaddr);
my $response = uc unpack 'H*', $msg;
printf "%-56s %s\n", "Received using UDP/9115 from $hishost response:", $response;
