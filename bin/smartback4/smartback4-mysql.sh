#!/bin/bash
#= smartback3-mysql.sh

# GRANT ALL PRIVILEGES ON *.* TO 'backupuser'@'localhost' IDENTIFIED BY 'Gac79tem41' WITH GRANT OPTION;
# UPDATE mysql.user SET Password=PASSWORD('Gac79tem41') WHERE User='backupuser';
# FLUSH PRIVILEGES;

mysqldump --all-databases -u backupuser --password=Gac79tem41 -c  | gzip -c > /var/backups/mysql/mysql.backup.sql.gz


