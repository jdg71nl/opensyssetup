#!/bin/bash

mysql -u root -p <<EOT
USE flexvpn; 
SELECT MAX(user_userid_n) FROM tbl_users WHERE user_serverid_n=2 AND user_groupid_n=1
EOT

