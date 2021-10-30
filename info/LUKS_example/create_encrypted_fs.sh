#!/bin/bash
# Shell script to set up an encrypted filesystem on a loopback device
# using LUKS.

# From an example by Paul Heinlein at
# http://wiki.centos.org/TipsAndTricks/EncryptedFilesystem
# Mods by Phil Schaffner

# Create an empty file sized to suit your needs. The file created
# will be a sparse file of the size in MB specified on the command line.
# No real blocks are written since we will force block allocation
# later on.

if [ "$#" -lt 2 ]; then
   echo $"Usage: $(basename $0) <path_to_file> <size_in_MB>"
   exit 1
fi

SECRET_PATH=$(dirname $1)
SECRET_FILE=$(basename $1)
SECRET_FS=$SECRET_PATH/$SECRET_FILE
if [ ! -d $SECRET_PATH ]; then
    echo "Directory $SECRET_PATH to hold encrypted filesystem does not exist!"
    exit 1
fi

if [ -f $SECRET_FS ]; then
    echo "File $SECRET_FS already exists.  Refusing to overwrite!"
    exit 1
fi

expr "$2 + 1" 2> /dev/null
if [ $? = 0 ]; then
    SECRET_SIZE=$2
else
    echo "Second parameter should be file size in MB."
    exit 1
fi

FREE_SPACE=$(df -m $SECRET_PATH |grep / | awk '{ print $4 }')
if [ $SECRET_SIZE -gt $FREE_SPACE ]; then
    echo "Not enough space on device for a $SECRET_SIZE MB file!"
    df -m $SECRET_PATH
    exit 1
fi

dd of=$SECRET_FS bs=1M count=0 seek=$SECRET_SIZE
# Lock down normal access to the file
chmod 600 $SECRET_FS

# Associate a loopback device with the file
LOOP_DEV=$(losetup -f)
losetup $LOOP_DEV $SECRET_FS

# Encrypt storage in the device. cryptsetup will use the Linux
# device mapper to create, in this case, /dev/mapper/$SECRET_FILE.
# The -y option specifies that you'll be prompted to type the
# passphrase twice (once for verification).  The first
# command initializes the volume, and sets an initial key. The
# second command opens the partition, and creates a mapping
# (in this case /dev/mapper/$SECRET_FILE).
cryptsetup -y luksFormat $LOOP_DEV
cryptsetup luksOpen $LOOP_DEV $SECRET_FILE

# Check return status and repeat until OK
while [ ! $? = 0 ]; do
    cryptsetup luksOpen $LOOP_DEV $SECRET_FILE
done

# Check its status (optional)
cryptsetup status $SECRET_FILE

# Now, we will write zeros to the new encrypted device. This
# will force the allocation of data blocks. And since the zeros
# are encrypted, this will look like random data to the outside
# world, making it nearly impossible to track down encrypted
# data blocks if someone gains access to the file that holds
# the encrypted filesystem.
dd if=/dev/zero of=/dev/mapper/$SECRET_FILE

# Create a filesystem and verify its status
mke2fs -j -O dir_index /dev/mapper/$SECRET_FILE
tune2fs -l /dev/mapper/$SECRET_FILE

# Mount the new filesystem in a convenient location
mkdir -p /mnt/cryptofs/$SECRET_FILE
mount /dev/mapper/$SECRET_FILE /mnt/cryptofs/$SECRET_FILE
df -m /dev/mapper/$SECRET_FILE
