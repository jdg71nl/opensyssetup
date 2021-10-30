#!/bin/bash
rsync -rtlv --delete -e "ssh -l syssetup" 91.184.11.145:/usr/local/syssetup /usr/local/
