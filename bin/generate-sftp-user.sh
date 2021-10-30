#!/bin/bash

USER=$1
if [[ -z "$USER" ]]; then
	echo "Usage: <unix-username>"
	exit 1;
fi

PLINE=$(cat /etc/passwd | egrep "^$USER:")
if [[ ! -z "$PLINE" ]]; then
	echo "User '$USER' already exists!"
	exit 1;
fi

echo "--- Creating user '$USER' ... "
CMD="useradd $USER"
echo $CMD
$CMD
echo "--- Type new password for the user '$USER':"
CMD="passwd $USER"
echo $CMD
$CMD
echo "--- Setting permissions to 'sftponly' for user '$USER' ...."
CMD="usermod -g sftponly $USER"
echo $CMD
$CMD
CMD="usermod -s /bin/false $USER"
$CMD
echo $CMD
CMD="usermod -d /home/$USER $USER"
echo $CMD
$CMD
CMD="chmod 755 /home/$USER"
echo $CMD
$CMD
CMD="chown root:root /home/$USER"
echo $CMD
$CMD
echo "--- Creating files-directory '/home/$USER/files'..."
CMD="mkdir /home/$USER/files"
echo $CMD
$CMD
CMD="chown $USER:sftponly /home/$USER/files/"
echo $CMD
$CMD
echo "--- Done!"

