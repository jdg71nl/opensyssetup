#!/bin/bash

# --[CWD=~/opensyssetup/info(git:main)]--[1708265485 15:11:25 Sun 18-Feb-2024 CET]--[jdg@rpi5-nvme-ubuntu]--[hw:RPI5b-1.0,os:Ubuntu-23.10/mantic,isa:aarch64]------
# > curl -s ipinfo.io/json
# {
#   "ip": "77.174.28.185",
#   "hostname": "77-174-28-185.fixed.kpn.net",
#   "city": "Amersfoort",
#   "region": "Utrecht",
#   "country": "NL",
#   "loc": "52.1550,5.3875",
#   "org": "AS1136 KPN B.V.",
#   "postal": "3811",
#   "timezone": "Europe/Amsterdam",
#   "readme": "https://ipinfo.io/missingauth"
# }

#curl -s ipinfo.io/json
#curl -s ipinfo.io/json | jq .org | tr -d '"'
#curl -H "Accept: application/json" ipinfo.io/8.8.8.8

IP="$1"

echo "curl -H 'Accept: application/json' -s ipinfo.io/$IP/json | jq .org | tr -d '\"' "
curl -H "Accept: application/json" -s ipinfo.io/$IP/json | jq .org | tr -d '"'

#-eof
