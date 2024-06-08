#!/bin/bash

EP="https://api.openprovider.eu/v1beta"
USER="uuu"
PASS="xxx"
if [ -f .secrets ]; then . .secrets ; fi

# curl -X POST https://api.openprovider.eu/v1beta/auth/login -d '{"username": "user", "password": "******", "ip": "0.0.0.0"}'
#
#curl -X POST $EP/auth/login -d "{\"username\":\"$USER\",\"password\":\"$PASS\",\"ip\":\"0.0.0.0\"}"

#TOKEN=$( curl -H "Accept: application/json" -s -X POST $EP/auth/login -d "{\"username\":\"$USER\",\"password\":\"$PASS\",\"ip\":\"0.0.0.0\"}" | jq .data.token | tr -d '"' )
AUTH_RESP=$( curl -H "Accept: application/json" -s -X POST $EP/auth/login -d "{\"username\":\"$USER\",\"password\":\"$PASS\",\"ip\":\"0.0.0.0\"}" )
TOKEN=$( echo $AUTH_RESP | jq .data.token | tr -d '"' )
#echo "# AUTH_RESP=$AUTH_RESP "
#echo "# TOKEN=$TOKEN "

#USER="jdg71dgt"
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712764643 17:57:23 Wed 10-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
#{"desc":"Authentication/Authorization 

#USER="john@dgt-bv.com"
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712764941 18:02:21 Wed 10-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
#{"code":0,"desc":"","data":{"token":"68833a93474e9be96b80e07f26fbf0f8","reseller_id":255401}}

#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712765541 18:12:21 Wed 10-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
#{"code":0,"desc":"","data":{"token":"adf7eadd321ebac20d5876c961d6f75c","reseller_id":255401}}

# curl -X POST https://api.openprovider.eu/v1beta/customers \
# -H 'Authorization: Bearer <auth token>' \
# -H 'Content-Type: application/json' \
# -d '{"address": {"street": "Albusstraat", "number": "83", "city": "Oosterhout", "zipcode": "4903 RG", "state": "Noord-Brabant", "country": "NL"},"company_name": "Hosters with Style", "email": "example@mail.tld", "fax": {"area_code": "111", "country_code": "+05", "subscriber_number": "123456"}, "name": {"first_name": "Carsten", "full_name": "Carsten G van Noort", "initials": "C.G.P.", "last_name": "van Noort", "prefix": "Dr."}, "phone": {"area_code": "111", "country_code": "+04", "subscriber_number": "123456"}, "tags": [{"key": "customer", "value": "VIP"}]}'

#curl -X GET \
#-H 'Authorization: Bearer <adf7eadd321ebac20d5876c961d6f75c>' \
#'https://api.openprovider.eu/v1beta/domains/'
## 'https://api.openprovider.eu/v1beta/domains/?limit=2&domain_name_pattern=greatdomain%2A&status=act'

#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712765595 18:13:15 Wed 10-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
#{"desc":"Access denied.","code":10005}

#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712765723 18:15:23 Wed 10-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
#{"desc":"Authentication/Authorization Failed","code":196}

#echo "# > curl -X GET -H \"Authorization: Bearer $TOKEN\" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act' "
#curl -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act'

#echo "# > curl -sSL -X GET -H \"Authorization: Bearer $TOKEN\" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act' "
#curl -sSL -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act'

# this gives good trace:
#echo "# > curl -v -s -o - -X GET -H \"Authorization: Bearer $TOKEN\" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act' "
#curl -v -s -o - -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act'

# now back to bare:
#echo "# > curl -X GET -H \"Authorization: Bearer $TOKEN\" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act' "
#curl -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act'
#
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712829117 11:51:57 Thu 11-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
## AUTH_RESP={"code":0,"desc":"","data":{"token":"9f9b6010e32537396675824e505abc73","reseller_id":255401}} 
## TOKEN=9f9b6010e32537396675824e505abc73 
## > curl -X GET -H "Authorization: Bearer 9f9b6010e32537396675824e505abc73" 'https://api.openprovider.eu/v1beta/domains/?limit=3&status=act' 
#{"desc":"Invalid status for domain","code":515}
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712829120 11:52:00 Thu 11-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------

#echo "# > curl -X GET -H \"Authorization: Bearer $TOKEN\" 'https://api.openprovider.eu/v1beta/domains/?limit=3' "
#curl -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=3'
#
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712829169 11:52:49 Thu 11-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------
#> ./get-opapi.sh 
# AUTH_RESP={"code":0,"desc":"","data":{"token":"38abf974193afcf0c96fba748151fea7","reseller_id":255401}} 
# TOKEN=38abf974193afcf0c96fba748151fea7 
# > curl -X GET -H "Authorization: Bearer 38abf974193afcf0c96fba748151fea7" 'https://api.openprovider.eu/v1beta/domains/?limit=3' 
#
#{"code":0,"desc":"","data":{"results":[{"id":18676288,"reseller_id":255401,"nsgroup_id":10522875,"domain":{"name":"zappa-internet","extension":"nl"},"name_servers":[{"seq_nr":0,"name":"ns1.zappa-internet.nl","ip":"193.38.153.10"},{"seq_nr":1,"name":"ns2.zappa-internet.nl","ip":"193.38.153.18"}],"is_lockable":false,"is_locked":false,"comments":"","comments_last_changed_at":"2021-02-18 09:46:27","creation_date":"2021-02-18 08:46:29","last_changed":"2024-02-18 11:23:15","order_date":"2021-02-18 09:46:27","active_date":"2024-02-16 10:10:35","expiration_date":"2025-02-18 08:46:29","registry_expiration_date":"2024-02-18 08:46:29","renewal_date":"2025-02-16 08:46:29","is_hosted_whois":false,"is_dnssec_enabled":true,"dnssec":"signedDelegation","status":"ACT","can_renew":true,"renew":2,"modify_owner_allowed":true,"autorenew":"default","owner_handle":"JD936110-NL","admin_handle":"JD936110-NL","tech_handle":"JD936110-NL","billing_handle":"","reseller_handle":"JD936110-NL","owner":{"company_name":"De Graaff Telecom Holding BV","full_name":"John mr. de Graaff"},"ns_template_id":0,"ns_template_name":"","type":"NEW","auth_code":"thm6X7tZtn6U","internal_auth_code":"0","trade_auth_code_required":"no","transfer_auth_code_required":"yes","transfer_cancel_supported":true,"trade_allowed":false,"use_domicile":false,"deleted_at":"0000-00-00 00:00:00","is_deleted":false,"is_private_whois_enabled":false,"is_private_whois_allowed":false,"has_history":true,"is_premium":false,"is_abusive":false,"is_spamexperts_enabled":false,"unit":"y","owner_company_name":"De Graaff Telecom Holding BV","is_parked":false,"dnssec_keys":[{"protocol":3,"flags":256,"alg":13,"pub_key":"luQjlmnMhmjRZdkV4RHbK2IFDkJmKzvlNNASPVBv37Ql+vp7ZmGlog4fFUpQHOqkGDuR2/g0k/c8YQWCYTiv7Q=="},{"protocol":3,"flags":257,"alg":13,"pub_key":"FxcIPbOcbh3TJEh3KcaVjSu+rgbHi8lTGdUh4uOrEaW0i2U4zR4WYVNe7n/g/i3NPmSqL/vuXVE4rnZ79Y5ryw=="}],"is_sectigo_dns_enabled":false},{"id":21083508,"reseller_id":255401,"nsgroup_id":12274257,"domain":{"name":"qam-internet","extension":"nl"},"name_servers":[{"seq_nr":0,"name":"ns1.zappa-internet.nl"},{"seq_nr":1,"name":"ns2.zappa-internet.nl"}],"is_lockable":false,"is_locked":false,"comments":"","comments_last_changed_at":"2021-07-21 11:48:31","creation_date":"2021-07-21 09:48:31","last_changed":"2023-07-19 10:06:31","order_date":"2021-07-21 11:48:31","active_date":"2023-07-19 10:06:30","expiration_date":"2024-07-21 09:48:31","registry_expiration_date":"2023-07-21 09:48:31","renewal_date":"2024-07-19 09:48:31","is_hosted_whois":false,"is_dnssec_enabled":true,"dnssec":"signedDelegation","status":"ACT","can_renew":true,"renew":2,"modify_owner_allowed":true,"autorenew":"default","owner_handle":"JD936110-NL","admin_handle":"JD936110-NL","tech_handle":"JD936110-NL","billing_handle":"","reseller_handle":"JD936110-NL","owner":{"company_name":"De Graaff Telecom Holding BV","full_name":"John mr. de Graaff"},"ns_template_id":0,"ns_template_name":"","type":"NEW","auth_code":"rjunceCEpvvZ","internal_auth_code":"0","trade_auth_code_required":"no","transfer_auth_code_required":"yes","transfer_cancel_supported":true,"trade_allowed":false,"use_domicile":false,"deleted_at":"0000-00-00 00:00:00","is_deleted":false,"is_private_whois_enabled":false,"is_private_whois_allowed":false,"has_history":true,"is_premium":false,"is_abusive":false,"is_spamexperts_enabled":false,"unit":"y","owner_company_name":"De Graaff Telecom Holding BV","is_parked":false,"dnssec_keys":[{"protocol":3,"flags":256,"alg":13,"pub_key":"luQjlmnMhmjRZdkV4RHbK2IFDkJmKzvlNNASPVBv37Ql+vp7ZmGlog4fFUpQHOqkGDuR2/g0k/c8YQWCYTiv7Q=="},{"protocol":3,"flags":257,"alg":13,"pub_key":"FxcIPbOcbh3TJEh3KcaVjSu+rgbHi8lTGdUh4uOrEaW0i2U4zR4WYVNe7n/g/i3NPmSqL/vuXVE4rnZ79Y5ryw=="}],"is_sectigo_dns_enabled":false},{"id":22011888,"reseller_id":255401,"nsgroup_id":12274259,"domain":{"name":"sostark","extension":"nl"},"name_servers":[{"seq_nr":0,"name":"ns1.j71.nl"},{"seq_nr":1,"name":"ns2.j71.nl"}],"is_lockable":false,"is_locked":false,"comments":"","comments_last_changed_at":"2021-09-07 22:15:11","creation_date":"2021-09-07 20:15:13","last_changed":"2023-09-05 21:12:27","order_date":"2021-09-07 22:15:11","active_date":"2023-09-05 21:12:26","expiration_date":"2024-09-07 20:15:13","registry_expiration_date":"2023-09-07 20:15:13","renewal_date":"2024-09-05 20:15:13","is_hosted_whois":false,"is_dnssec_enabled":true,"dnssec":"signedDelegation","status":"ACT","can_renew":true,"renew":2,"modify_owner_allowed":true,"autorenew":"default","owner_handle":"JD936109-NL","admin_handle":"JD936109-NL","tech_handle":"JD936109-NL","billing_handle":"","reseller_handle":"JD936109-NL","owner":{"company_name":"De Graaff Telecom Holding BV","full_name":"John de Graaff"},"ns_template_id":0,"ns_template_name":"","type":"NEW","auth_code":"EpNCmpWadhA2","internal_auth_code":"0","trade_auth_code_required":"no","transfer_auth_code_required":"yes","transfer_cancel_supported":true,"trade_allowed":false,"use_domicile":false,"deleted_at":"0000-00-00 00:00:00","is_deleted":false,"is_private_whois_enabled":false,"is_private_whois_allowed":false,"has_history":true,"is_premium":false,"is_abusive":false,"is_spamexperts_enabled":false,"unit":"y","owner_company_name":"De Graaff Telecom Holding BV","is_parked":false,"dnssec_keys":[{"protocol":3,"flags":256,"alg":13,"pub_key":"luQjlmnMhmjRZdkV4RHbK2IFDkJmKzvlNNASPVBv37Ql+vp7ZmGlog4fFUpQHOqkGDuR2/g0k/c8YQWCYTiv7Q=="},{"protocol":3,"flags":257,"alg":13,"pub_key":"FxcIPbOcbh3TJEh3KcaVjSu+rgbHi8lTGdUh4uOrEaW0i2U4zR4WYVNe7n/g/i3NPmSqL/vuXVE4rnZ79Y5ryw=="}],"is_sectigo_dns_enabled":false}],"total":26}}
#--[CWD=~/dev/dns-de-graaffnet/bin/test(git:master)]--[1712829171 11:52:51 Thu 11-Apr-2024 CEST]--[jdg@vps3]--[os:Debian-11/bullseye,isa:x86_64]------

DATE=`date +d%y%m%d-%H%M%S`
FILE="dgt-op-alldomains.$DATE.json"
#
curl -X GET -H "Authorization: Bearer $TOKEN" 'https://api.openprovider.eu/v1beta/domains/?limit=100' > $FILE

#-eof

