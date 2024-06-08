#!/bin/bash

cat <<HERE
#= mac_install_postgres.sh 
# .. on how to install postgres, apache2 and adminer on MacOS

# https://www.postgresql.org/download/macosx/
# for click-launch: https://postgresapp.com/
#
# for permanent install:
> brew install postgresql@15 
> brew services start postgresql@15 
> brew services restart postgresql@15 
> brew services stop postgresql@15 

# NO !! -- this is for MySQL only:
# download & install: https://www.sequelpro.com/ "

> brew install httpd php 
> brew services start httpd 
> brew services restart httpd 
> brew services stop httpd 

# note: the apache2 httpd service is bound on port 8080 (so we don't need sudo):
http://127.0.0.1:8080/

# brew says:
- DocumentRoot is /opt/homebrew/var/www
- The default ports have been set in /opt/homebrew/etc/httpd/httpd.conf to 8080 and in
- /opt/homebrew/etc/httpd/extra/httpd-ssl.conf to 8443 so that httpd can run without sudo.

#
> head /opt/homebrew/etc/httpd/httpd.conf
#
# This is the main Apache HTTP server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See <URL:http://httpd.apache.org/docs/2.4/> for detailed information.
# In particular, see 
# <URL:http://httpd.apache.org/docs/2.4/mod/directives.html>
# for a discussion of each configuration directive.

#
> lt /opt/homebrew/var/www 
total 8
drwxr-xr-x  6 jdg  admin   192B May 14 18:09 cgi-bin/
drwxr-xr-x  4 jdg  admin   128B May 14 18:09 ./
-rw-r--r--  1 jdg  admin    45B May 14 18:09 index.html
drwxrwxr-x  8 jdg  admin   256B May 14 18:09 ../

#
> cat /opt/homebrew/var/www/index.html 
<html><body><h1>It works!</h1></body></html>

# brew says on: PHP
# To enable PHP in Apache add the following to httpd.conf and restart Apache:
LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so
<FilesMatch \.php$>
  SetHandler application/x-httpd-php
</FilesMatch>
# Finally, check DirectoryIndex includes index.php
DirectoryIndex index.php index.html
# The php.ini and php-fpm.ini file can be found in: /opt/homebrew/etc/php/8.3/
# To start php now and restart at login:
> brew services start php

# install adminer: https://github.com/orsenthil/adminer-on-mac 
> curl-save https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-en.php
> cp -v adminer-4.8.1-en.php /opt/homebrew/var/www/
> cd /opt/homebrew/var/www/
> ln -s adminer-4.8.1-en.php  adminer.php
> brew services restart httpd 

#.
HERE

#-eof

