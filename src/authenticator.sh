#!/bin/bash

# Get your API key from https://www.cloudflare.com/a/account/my-account
USERNAME=""
API_KEY=""

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

echo CERTBOT_DOMAIN: $CERTBOT_DOMAIN
echo DOMAIN: $DOMAIN
echo CERTBOT_VALIDATION: $CERTBOT_VALIDATION

# Create TXT record
echo Create TXT record
curl -u "$USERNAME:$API_KEY" -s -X GET "https://dynamic.zoneedit.com/txt-create.php?host=_acme-challenge.$CERTBOT_DOMAIN&rdata=$CERTBOT_VALIDATION"
# Sleep to make sure the change has time to propagate over to DNS
# echo Sleep for 25 seconds to allow time to propagate
sleep 120
