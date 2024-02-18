<!-- usage: curl https://dgt-bv.com/whatismyip.php -->
<pre>
<?php 

$ip = getenv("REMOTE_ADDR") ; 

$dns = gethostbyaddr($ip);
if ($dns == $ip) { $dns = "(no PTR-record)"; }

#$get_org = "~/opensyssetup/bin/ipinfo_io_json.sh";
$get_org = "/home/jdg/opensyssetup/bin/ipinfo_io_json.sh";
$org = exec($get_org);

print "Your IP address is                : $ip\n"; 
print "The DNS PTR-record for your IP is : $dns\n";
print "The ISP/Provider (org) name is    : $org\n";
print "Local time on server is           : ".date("r")."\n";
print "Local time in Unix-Epoch seconds  : ".date("U")."\n";
print "\n";
print "JSON:\n";
print "{\"ip\":\"$ip\",\"dns\":\"$dns\",\"org\":\"$org\",\"time_str\":\"".date("r")."\",\"time\":".date("U")."} \n";
print "\n";

# phpinfo();
?>
</pre>
