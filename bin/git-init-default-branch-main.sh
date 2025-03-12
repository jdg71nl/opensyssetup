#!/bin/bash
#= git-init-default-branch-main.sh 

# 'git init' ==> uses default 'master' as the default branch, see this part in docs:
# https://git-scm.com/docs/git-init
# -b <branch-name>
# --initial-branch=<branch-name>
# Use <branch-name> for the initial branch in the newly created repository. If not specified, fall back to the default name (currently master, but this is subject to change in the future; the name can be customized via the init.defaultBranch configuration variable).

# https://superuser.com/questions/1419613/change-git-init-default-branch-name
# do this before 'git init' :
# > git config --global init.defaultBranch main

set -o xtrace 

git config --global init.defaultBranch main

git init

#-EOF

