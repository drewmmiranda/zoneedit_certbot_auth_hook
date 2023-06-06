# zoneedit_certbot_auth_hook
Crude proof of concept of a certbot --manual-auth-hook for zoneedit

## What is this?

This is a quick and dirty proof of concept to go through the process of learning how to automate [Let's Encrypt](https://letsencrypt.org/) certificate requests and renewals. My current DNS provider, [zoneedit](https://www.zoneedit.com/), did not appear to have any integrations for this, but does have some API endpoints that can be used for this task.

I put this together before finding other alternatives:

* https://github.com/jeansergegagnon/zoneedit_letsencrypt
* https://github.com/zlaski/certbot-dns-zoneedit


## How to use

Example command to generate wildcard certificate for the specified domain:

```sh
sudo certbot certonly --manual -n --agree-tos -m <email address> --preferred-challenges=dns --manual-auth-hook /path/to/authenticator.sh -d *.domain.tld
```

Be sure to update values for `<email address>` and `*.domain.tld`.

### Example output

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for *.domain.tld
Hook '--manual-auth-hook' for domain.tld ran with output:
 CERTBOT_DOMAIN: domain.tld
 DOMAIN:
 CERTBOT_VALIDATION: <txt record value>
 Create TXT record
 <SUCCESS CODE="200" TEXT="_acme-challenge.domain.tld TXT updated to <txt record value>" ZONE="domain.tld">

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/domain.tld/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/domain.tld/privkey.pem
This certificate expires on <date>.
These files will be updated when the certificate renews.
```

## What do the files do?

### authenticator.sh

Used with certbot via the `--manual-auth-hook` argument. Handles updating the TXT record.

Adapted from authenticator.sh example via https://eff-certbot.readthedocs.io/en/stable/using.html#pre-and-post-validation-hooks

### cleanup-txt.py

Script that uses dig to obtain a list of TXT records of a specified domain and uses the zoneedit `txt-delete.php` url to delete all txt records.

## Todo

* rewrite `authenticator.sh` to use python (which i personally find much easier to work with)
* better automate remove of TXT record as a cleanup action (`--manual-cleanup-hook`)
* use a config file to store usename and password/dynamic api key