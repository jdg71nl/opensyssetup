#!/bin/bash
# Drop_File_Showpath.sh
# Create Automator script Drop_File_Showpath.app using "Run Shell Script" and copy/paste there contents of this .sh file

# 
# d180912 NOTE !!!!!----- below script does not work, and there is an easy alternative: [drop file/folder in SecureCRT]
#

function doshow {
	# osascript -e "tell app 'Finder' to display dialog '$1' "
	osascript -e 'tell app "System Events" to display dialog "'$1'" buttons "OK" default button 1 with title "Drop_File_Showpath"'
}

STRING=""

for FILE in "$@" ; do

	if [[ -d "$FILE" ]]; then
		# STRING="$STRING\n$FILE/" ;
		# continue ; 
		doshow "$FILE/";
	else
		# STRING="$STRING\n$FILE" ;
		doshow "$FILE";
	fi ;
	break;
done ;
# doshow "$STRING";

# https://stackoverflow.com/questions/5588064/how-do-i-make-a-mac-terminal-pop-up-alert-applescript
# osascript -e 'tell app "Finder" to display dialog "Hello World"' 
# sudo gem install terminal-notifier

# https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/DisplayDialogsandAlerts.html

