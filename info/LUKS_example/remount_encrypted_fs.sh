#!/bin/bash
# Shell script to remount encrypted filesystem on a loopback device
# using LUKS.

# From an example by Paul Heinlein at
# http://wiki.centos.org/TipsAndTricks/EncryptedFilesystem
# Mods by Phil Schaffner

if [ "$#" -lt 1 ]; then
   echo $"Usage: $(basename $0) <path_to_encrypted_file>"
   exit 1
fi

SECRET_PATH=$(dirname $1)
SECRET_FILE=$(basename $1)
SECRET_FS=$SECRET_PATH/$SECRET_FILE

if [ ! -f $SECRET_FS ]; then
    echo "File $SECRET_FS not found!"
    exit 1
fi

# Associate a loopback device with the file
LOOP_DEV=$(losetup -f)
losetup $LOOP_DEV $SECRET_FS

# Set up encryption on the device
cryptsetup luksOpen $LOOP_DEV $SECRET_FILE

# Check return status and repeat until OK
while [ ! $? = 0 ]; do
    cryptsetup luksOpen $LOOP_DEV $SECRET_FILE
done

# Check its status (optional)
cryptsetup status $SECRET_FILE

# Mount the new filesystem in a convenient location
if [ ! -d /mnt/cryptofs/$SECRET_FILE ]; then
    mkdir -p /mnt/cryptofs/$SECRET_FILE
fi

mount /dev/mapper/$SECRET_FILE /mnt/cryptofs/$SECRET_FILE
df -m /dev/mapper/$SECRET_FILE
