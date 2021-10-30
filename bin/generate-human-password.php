<?php
# runs as: php -f generate-human-password.php 

function generateHumanPassword($pattern='cvcddcvcdd') {
	$vowels     = 'aeuy'; # not: oi
	$consonants = 'bcdfghjkmnpqrstvwxz'; # not: l
	$digits     = '23456789'; # not: 01
 
	$length=strlen($pattern);

	$password = '';
	for ($i = 0; $i < $length; $i++) {
		if ($pattern[$i] == 'v') {
			$password .= $vowels[(rand() % strlen($vowels))];
		}
		if ($pattern[$i] == 'c') {
			$password .= $consonants[(rand() % strlen($consonants))];
		}
		if ($pattern[$i] == 'd') {
			$password .= $digits[(rand() % strlen($digits))];
		}
	}
	return $password;
}

# http://www.webtoolkit.info/php-random-password-generator.html
function generatePassword($length=9, $strength=0) {
	$vowels = 'aeuy';
	$consonants = 'bdghjmnpqrstvz';
	if ($strength & 1) {
		$consonants .= 'BDGHJLMNPQRSTVWXZ';
	}
	if ($strength & 2) {
		$vowels .= "AEUY";
	}
	if ($strength & 4) {
		$consonants .= '23456789';
	}
	if ($strength & 8) {
		$consonants .= '@#$%';
	}
 
	$password = '';
	$alt = time() % 2;
	for ($i = 0; $i < $length; $i++) {
		if ($alt == 1) {
			$password .= $consonants[(rand() % strlen($consonants))];
			$alt = 0;
		} else {
			$password .= $vowels[(rand() % strlen($vowels))];
			$alt = 1;
		}
	}
	return $password;
}
 
#$pwd = generatePassword(10,10);
#print "$pwd\n";

$pwd = generateHumanPassword();
print "$pwd\n";

?>

