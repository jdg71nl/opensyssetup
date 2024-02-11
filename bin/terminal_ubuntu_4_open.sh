#!/bin/bash

# https://unix.stackexchange.com/questions/43106/how-to-set-window-size-and-location-of-an-application-on-screen-via-command-line
# https://en.wikipedia.org/wiki/Wmctrl

# gnome-terminal --geometry 182x46 --title "term-jdg-1"

# https://stackoverflow.com/questions/6678865/getting-pid-of-a-background-gnome-terminal-process
#
gnome-terminal --disable-factory --geometry 182x46 --title "term-jdg-1" &
gnome-terminal --disable-factory --geometry 182x46 --title "term-jdg-2" &
gnome-terminal --disable-factory --geometry 182x46 --title "term-jdg-3" &
gnome-terminal --disable-factory --geometry 182x46 --title "term-jdg-4" &

#: --[CWD=~]--[1707649123 11:58:43 Sun 11-Feb-2024 CET]--[jdg@rpi5-nvme-ubuntu]--[hw:RPI5b-1.0,os:Ubuntu-23.10/mantic,isa:aarch64]------
#: > psg term
#: jdg         2985  3.5  1.2 688592 103172 ?       Ssl  11:27   1:08 /usr/libexec/gnome-terminal-server
#: jdg        15655  2.9  0.2 334416 20096 pts/3    Sl   11:58   0:00 /usr/bin/python3 /usr/bin/gnome-terminal --disable-factory --geometry 182x46 --title term-jdg-1
#: jdg        15664 23.1  0.7 642280 58332 pts/3    Sl   11:58   0:00 /usr/libexec/gnome-terminal-server --app-id com.canonical.Terminal.HtDKKkPfWkUnafrCMCstSLRlzKDEWGvU
#: jdg        15769  0.0  0.0   9264  1792 pts/4    S+   11:58   0:00 grep --color=auto term
#: 

# Process ID of the process we just launched
PID=$!
#echo "# PID=$PID "

# Window ID of the process...pray that there's     
# only one window! Otherwise this might break.
# We also need to wait for the process to spawn
# a window.
#
#while [ "$WID" == "" ]; do
#  WID=$(wmctrl -lp | grep $PID | cut "-d " -f1)
#done

# Set the size and location of the window
# See man wmctrl for more info
#wmctrl -i -r $WID -e 0,50,50,250,250

#-eof

