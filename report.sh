#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile
source $path/env

version=$(/root/nexus-cli/clients/cli/target/release/nexus-network -V | awk '{print $NF}')
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -c -E "rror|ERR")
success=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c "Successfully submitted proof")

status="ok";message="";
[ $errors -gt 100 ] && status="warning" && message="too many errors";
[ $service -ne 1 ] && status="error" && message="service not running";

cat >$json << EOF
{
  "updated":"$(date --utc +%FT%TZ)",
  "measurement":"report",
  "tags": {
       "id":"$folder-$ID",
       "machine":"$MACHINE",
       "grp":"node",
       "owner":"$OWNER"
  },
  "fields": {
        "chain":"testnet3",
        "network":"testnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":$service,
        "errors":$errors,
        "m1":"success=$success"
        "m2":"id=$NODEID"
  }
}
EOF

cat $json | jq
