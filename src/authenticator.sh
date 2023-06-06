#!/bin/bash

# Zoneedit username
USERNAME=""
# Zoneedit Dynamic token
# See https://support.zoneedit.com/en/knowledgebase/article/dynamic-dns
API_KEY=""

# Strip only the top domain to get the zone id
# This does not work. CERTBOT_DOMAIN is already only the domain without any subdomains
# The below retuns "" if CERTBOT_DOMAIN is a domain name, which in my limited testing it always is
# DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

# Variables obtained from certbot
echo CERTBOT_DOMAIN: $CERTBOT_DOMAIN
# echo DOMAIN: $DOMAIN
echo CERTBOT_VALIDATION: $CERTBOT_VALIDATION

# Create TXT record
echo Create TXT record
curl -u "$USERNAME:$API_KEY" -s -X GET "https://dynamic.zoneedit.com/txt-create.php?host=_acme-challenge.$CERTBOT_DOMAIN&rdata=$CERTBOT_VALIDATION"

# Sleep to make sure the change has time to propagate over to DNS
# Zoneedit seems to take a fairly long time for these TXT updates to be queryable
sleep 120
