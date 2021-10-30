#!/bin/bash
# add in (visudo) /etc/sudoers: pureftp  ALL = NOPASSWD: /www/john.de-graaff.net/delete_cache_wiki_jdg.sh
rm -rf /www/john.de-graaff.net/wiki/data/cache/*
#
#<?php
#	$cmd="/www/john.de-graaff.net/delete_cache_wiki_jdg.sh";
#	print "done! cmd:$cmd";
#	system("sudo $cmd");
#?>
