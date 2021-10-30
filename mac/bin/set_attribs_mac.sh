#!/bin/bash

cd /usr/local/syssetup/

chown -R jdg:staff .

find . \( -type d -exec chmod 755 "{}" \; \) -o \
	\( \
		-type f -a \
		\( \
			\( -iname '*.sh' -exec chmod 755 "{}" \; \) -o \
			\( -iname '*.pl' -exec chmod 755 "{}" \; \) -o \
			-exec chmod 644 "{}" \; \
		\) \
	\)
echo


