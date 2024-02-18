#!/bin/bash
#= git-config-jdg.sh
# (c)2024 John@de-Graaff.net
#
git config --global user.name "John de Graaff"
git config --global user.email john@de-graaff.net
git config --global alias.ss "status -s"        # short status
git config --global alias.logg "log --oneline --decorate --graph --all --pretty=format:'%C(auto)%h %aD %d %s'"
git config --global alias.logn "log --oneline --decorate --graph --all --pretty=format:'%h - %ae - %ad : %s' --numstat"
git config --global pull.rebase false
#
#-EOF
