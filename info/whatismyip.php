<?php $ip = getenv("REMOTE_ADDR") ; ?>
<head>
<html>
<title><?php Echo "whatismyip.php answer: " . $ip; ?></title>
</head>
<body>
<PRE>
<?php 
print "Your IP is $ip \n"; 
print "\n"; 

//print var_dump($_SERVER);

print "Local time on server: ".date("r")."\n";
?>
</PRE>
</body>
</html>

