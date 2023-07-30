#!/bin/bash
#= smartback4-mysql.sh

# GRANT ALL PRIVILEGES ON *.* TO 'backupuser'@'localhost' IDENTIFIED BY 'my_pwd' WITH GRANT OPTION;
# UPDATE mysql.user SET Password=PASSWORD('my_pwd') WHERE User='backupuser';
# FLUSH PRIVILEGES;

mysqldump --all-databases -u backupuser --password=my_pwd -c  | gzip -c > /var/backups/mysql/mysql.backup.sql.gz


