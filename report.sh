#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile

version=$(echo ?)
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -n 1000 -u $folder.service --no-hostname -o cat | grep -c -E "rror|ERR")
prover_identifier=$(journalctl -u $folder.service --no-hostname -o cat | grep "Your current prover identifier is " | tail -1 | awk -F "Your current prover identifier is " '{print $NF}' | cut -d \) -f 1 )
url=

status="ok"
[ $service -ne 1 ] && status="error";message="service not running";
[ $errors -gt 20 ] && status="warning";message="errors=$errors";

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
       "id":"$folder",
       "machine":"$MACHINE",
       "grp":"node",
       "owner":"$OWNER"
  },
  "fields": {
        "chain":"testnet",
        "network":"testnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":$service,
        "errors":$errors,
        "prover_identifier":"$prover_identifier",
        "url":"$url"
  }
}
EOF

cat $json | jq
