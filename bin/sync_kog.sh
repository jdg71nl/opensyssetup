#!/bin/bash

rsync -rptgo -v -P --exclude='*.kml' --exclude='*.kml' /www/john.de-graaff.net/kog/ /usr/local/syssetup/projects/www/john.de-graaff.net/kog/

