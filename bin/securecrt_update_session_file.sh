#!/bin/bash
# securecrt_update_session_file.sh
# (c)2016 John de Graaff @ De Graaff Innovations VOF <john@dgi-vof.com>

# > perl -e '$x = 0x000001f4; print "$x\n";'
# 500
# > perl -e '$x = 0x0001e078; print "$x\n";'          
# 123000

FILE="$1"

FIND='"Scrollback"'
NEW1='"Scrollback"=0001e078'
/usr/local/syssetup/bin/securecrt_update_session_file_item.sh "$FILE" "$FIND" "$NEW1"

# S:"Log Filename V2"=/Users/jdg/Library/Application Support/VanDyke/SecureCRT/Logs/SecureCRT--Host_%H--Session_%S--d16%M%D%h%m.log.txt

/Users/jdg/Library/Application Support/VanDyke/SecureCRT/Logs/SecureCRT--LOCAL--d16%M%D%h%m.log.txt
/Users/jdg/Library/Application Support/VanDyke/SecureCRT/Logs/SecureCRT--SERIAL--d16%M%D%h%m.log.txt
/Users/jdg/Library/Application Support/VanDyke/SecureCRT/Logs/SecureCRT--SSH-Host_%H-Session_%S--d16%M%D%h%m.log.txt
/Users/jdg/Library/Application Support/VanDyke/SecureCRT/Logs/SecureCRT--TELNET-Host_%H-Session_%S--d16%M%D%h%m.log.txt

D:"Start Log Upon Connect"=00000001
D:"Close On Disconnect"=00000001
S:"Protocol Name"=Local Shell
S:"Protocol Name"=Serial
S:"Protocol Name"=Telnet
S:"Protocol Name"=SSH2

