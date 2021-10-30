#!/bin/bash

# read the config file:
CONF=$1
if [[ -z "$CONF" ]]; then
	echo "Usage: $0 <csr-input.config.txt>"
	exit 1;
fi
if [[ ! -f "$CONF" ]]; then
	echo "Config file '$CONF' not readable!"
	exit 1;
fi

# source the config file:
. $CONF

# check if config makes sense:
if [[ -z "$CN" ]]; then
	echo "Invalid config in file '$CONF'! --see example in $0"
	exit 1;
fi

CN2=$( echo $CN | sed 's/\*/wildcard/' )
#echo "\$CN2 = '$CN2'" ; exit

# check if KEY/CSR files already exist:
FILE="$CN2.$VER.key"
if [[ -f "$FILE" ]]; then
	echo "File '$FILE' already exists!"
	exit 1;
fi
FILE="$CN2.$VER.csr"
if [[ -f "$FILE" ]]; then
	echo "File '$FILE' already exists!"
	exit 1;
fi

# for 2048-bits key use '-newkey rsa:2048' instead of '-new'

# https://www.sslcertificaten.nl/support/OpenSSL/OpenSSL_-_Aanmaken_CSR
# advice: CSR met ECC Private key

# OLD: openssl req -days 3650 -nodes -newkey rsa:2048 -batch -keyout "$CN.$VER.key" -out "$CN.$VER.csr" -subj "/C=$SSL_country/ST=$SSL_province/L=$SSL_city/O=$SSL_organization/OU=$SSL_organizationunit/CN=$CN/emailAddress=$SSL_email"

echo "# running commands: "

echo "> openssl ecparam -out \$CN2.\$VER.key -name prime256v1 -genkeya"
openssl ecparam -out "$CN2.$VER.key" -name prime256v1 -genkey

echo "> openssl req -new -key \$CN2.\$VER.key -out \$CN2.\$VER.csr -nodes -batch -subj /C=\$SSL_country/ST=\$SSL_province/L=\$SSL_city/O=\$SSL_organization/OU=\$SSL_organizationunit/CN=\$CN/emailAddress=\$SSL_email"
openssl req -new -key "$CN2.$VER.key" -out "$CN2.$VER.csr" -nodes -batch -subj "/C=$SSL_country/ST=$SSL_province/L=$SSL_city/O=$SSL_organization/OU=$SSL_organizationunit/CN=$CN/emailAddress=$SSL_email"

TXT="$CN2.$VER.csr.txt"
touch $TXT
echo "> openssl ecparam -out \$CN2.\$VER.key -name prime256v1 -genkeya" >> $TXT
echo "> openssl ecparam -out $CN2.$VER.key -name prime256v1 -genkeya" >> $TXT
echo "> openssl req -new -key \$CN2.\$VER.key -out \$CN2.\$VER.csr -nodes -batch -subj /C=\$SSL_country/ST=\$SSL_province/L=\$SSL_city/O=\$SSL_organization/OU=\$SSL_organizationunit/CN=\$CN/emailAddress=\$SSL_email" >> $TXT
echo "> openssl req -new -key $CN2.$VER.key -out $CN2.$VER.csr -nodes -batch -subj /C=$SSL_country/ST=$SSL_province/L=$SSL_city/O=$SSL_organization/OU=$SSL_organizationunit/CN=$CN/emailAddress=$SSL_email" >> $TXT
echo "> openssl req -text -noout -in \$CN2.\$VER.csr" >> $TXT
echo "> openssl req -text -noout -in $CN2.$VER.csr" >> $TXT
openssl req -text -noout -in $CN2.$VER.csr >> $TXT

echo "Created files:"
echo "Certificate Private Kay          : $CN2.$VER.key"
echo "Certificate Signing Request (CSR): $CN2.$VER.csr"
echo 
echo "Use this command to inspect CSR: openssl req -text -noout -in $CN2.$VER.csr"
echo "# (already send this info to file: $TXT ...)"

# ---
# below: config example (copy to seperate "CommonName.csr-input.config.txt" file):
# ---

# config file for "generate_openssl_csr.sh"
# (save as "$CN2.$VER.csr-input.config.txt" for documentation purposes)
#
CN="www.common-name-domain.com"
VER="1"
SSL_country="CO"
SSL_province="Provence name"
SSL_city="Cty name"
SSL_organization="Organisation name"
SSL_organizationunit="Organization unit name"
SSL_email="email-address.that.appears.in.certificate@domain.tld"
#
# use this command to generate CSR:
# generate_openssl_csr.sh $CN2.$VER.csr-input.config.txt
#

