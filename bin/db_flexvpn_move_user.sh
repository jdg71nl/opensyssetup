#!/bin/bash

mysql -u root -p <<EOT
USE flexvpn;
UPDATE tbl_users SET user_loginname_s='jvrooij_old' WHERE user_loginname_s='jvrooij';
INSERT INTO tbl_users (
user_serverid_n, 
user_groupid_n, 
user_userid_n, 
user_isadmin_n,
user_loginname_s,
user_passwd_s,
user_enabled_n,
user_fullname_s,
user_email_s
) VALUES (
2,
1,
38,
0,
'jvrooij',
'(ldap)',
1,
'Jan van Rooij',
'jvrooij@twswireless.com'
);
EOT

