#!/bin/bash
# from: https://www.cyberciti.biz/faq/how-do-i-check-my-bash-version/
echo "# some ways to get the BASH version: "
echo "# > within shell press: Ctrl+x Ctrl+v "
echo "# > echo \"\$BASH_VERSION\" "
echo "$BASH_VERSION"
echo "# > printf \"%s\n\" \$BASH_VERSION "
printf "%s\n" $BASH_VERSION
# EOF
