import requests, configparser, argparse, time, json, re, os, subprocess, urllib3, yaml
from requests.auth import HTTPBasicAuth
from os.path import exists

USERNAME = ""
API_KEY = ""

# Disable HTTPS/TLS certificate warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

parser = argparse.ArgumentParser(description="Just an example",
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("--domain", help="top level domain name to cleanup txt records from", type=str, required=True)

args = parser.parse_args()

process = subprocess.Popen(['dig', '-t', 'txt', '_acme-challenge.' + args.domain, '+short'], 
                           stdout=subprocess.PIPE,
                           universal_newlines=True)

def delete_txt_record(arg_domain, arg_txt, auth_user, auth_pass):
    sHeaders = {"User-Agent":"python", "Accept":"*/*"}

    print("Deleting TXT: " + arg_txt)
    sUrl = "https://dynamic.zoneedit.com/txt-delete.php?host=_acme-challenge." + arg_domain + "&rdata=" + arg_txt
    # print(sUrl)
    r = requests.get(sUrl, headers=sHeaders, verify=False, auth=HTTPBasicAuth(auth_user, auth_pass))
    print(r.status_code)
    # print(r.headers)
    # print(r.text)
    # print()

i = 0
for output in process.stdout.readlines():
    line = output.strip()
    res_str = re.sub(r"\"", "", line)
    delete_txt_record(args.domain, res_str, USERNAME, API_KEY)