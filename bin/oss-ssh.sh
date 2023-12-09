#!/bin/bash
# Usage:
# if you want to make direct changes ==> curl https://j71.nl/oss-ssh.sh   | bash 
# if you want to make it read-only*  ==> curl https://j71.nl/oss-https.sh | bash 
#                                 or ==> curl https://j71.nl/oss          | bash 
# (*) you can still make changes in a temporary branch, push using https, and use a access-token (purpose-pwd), or commit to new branch and create a pull-request
#
mkdir -pv $HOME/.ssh && chmod 0700 $HOME/.ssh
if [ ! -f $HOME/.ssh/id_rsa ] ; then echo "# Creating _new_ SSH-keypair ..." ; date > $HOME/.ssh/id_rsa.generate.txt ; ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P '' >> $HOME/.ssh/id_rsa.generate.txt; fi
echo "# copy this key to your Github account my-SSH-keys ==> cat \$HOME/.ssh/id_rsa.pub"
echo "# "
cat $HOME/.ssh/id_rsa.pub 
echo "# "
#
echo "# hit <ENTER> if Github-stuff is done, else <CTRL>-C ..."
read
#
cd $HOME
git clone --depth=1 git@github.com:jdg71nl/opensyssetup.git
./opensyssetup/setup.sh
#-EOF
