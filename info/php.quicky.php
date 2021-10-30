
<!-- Example variable names for statefull PHP forms: -->
HTML:
	<?php print $pLogin ?>: <INPUT TYPE="text" NAME="fLogin" VALUE="<?php print $tLogin; ?>">
PHP:
	$fLogin = escape_string ($_POST['fLogin']);
	$tLogin = $fLogin;
	$pLogin = "Loginname";
Usage:
	fVar = form-variable (last form-submit)
	tVar = temp-variable (defaults for new form-submit)
	pVar = print-variable
<!-- -->
