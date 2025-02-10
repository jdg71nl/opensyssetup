#!/bin/bash

# https://code.visualstudio.com/docs/setup/mac
#
# --[CWD=~/opensyssetup(git:main)]--[1705867071 20:57:51 Sun 21-Jan-2024 CET]--[jdg@MB18-jdg71nl]--[os:MacOS--13.6.3,isa:x86_64]------
# > lt /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code
# -rwxr-xr-x  1 jdg  staff   1.0K Jan 18 15:28 /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
#
#export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
#
# above gives errors on non-Mac platforms
# better create symlink:
# > ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code ~

echo # > ln -sv /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code ~
ln -sv /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code ~

echo # > sudo ln -sv /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/
sudo ln -sv /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/

#-eof

