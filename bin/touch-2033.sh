#!/bin/bash
#= touch-2033.sh

# > touch -t 209901020304 some  
# > stat some                   
#  File: some
#    Size: 0               Blocks: 0          IO Block: 4096   regular empty file
#    Device: 801h/2049d      Inode: 920706      Links: 1
#    Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
#    Access: 2099-01-02 03:04:00.000000000 +0100
#    Modify: 2099-01-02 03:04:00.000000000 +0100
#    Change: 2021-03-11 13:34:31.860856312 +0100

echo "# > touch -t 203301020304 $@ "
touch -t 203301020304 $@

