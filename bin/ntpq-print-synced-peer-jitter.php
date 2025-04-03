<?php
$output = shell_exec("ntpq -n -c peers 2>/dev/null  | /bin/grep '^\*.* u ' | awk '{ print $10 }'");
$myObj->jitter = $output;
$myJSON = json_encode($myObj);
header('Content-Type: application/json; charset=utf-8');
echo $myJSON;
?>

