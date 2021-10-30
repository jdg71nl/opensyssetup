#!/bin/bash
# Shell script to unmount an encrypted filesystem on a loopback device
# using LUKS.

# From an example by Paul Heinlein at
# http://wiki.centos.org/TipsAndTricks/EncryptedFilesystem
# Mods by Phil Schaffner

if [ "$#" -lt 1 ]; then
   echo $"Usage: $(basename $0) <path_to_file>"
   exit 1
fi

SECRET_PATH=$(dirname $1)
SECRET_FILE=$(basename $1)
SECRET_FS=$SECRET_PATH/$SECRET_FILE

if [ ! -f $SECRET_FS ]; then
    echo "File $SECRET_FS does not exist!"
    exit 1
fi

# Unmount the filesystem
umount /mnt/cryptofs/$SECRET_FILE

# Remove device mapping
cryptsetup luksClose $SECRET_FILE

# Find the loopback device and remove it
LOOP_DEV=$(losetup -a | grep $SECRET_FS | cut -f 1 -d ':')
if [ -z $LOOP_DEV ]; then
    echo "No loopback device found for ${SECRET_FS}!"
else
    losetup -d $LOOP_DEV
fi
