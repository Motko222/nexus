#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile

version=$(echo ?)
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -c -E "rror|ERR")
node_id=$(cat /root/.nexus/node-id)
last_proof=$(journalctl -u $folder.service --no-hostname -o cat | grep "Starting proof" | tail -1 | awk '{print $3}' | sed 's/...//')

status="ok";message="last=$last_proof";
[ $errors -gt 100 ] && status="warning" && message="errors";
[ $service -ne 1 ] && status="error" && message="service not running";

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
        "chain":"testnet2",
        "network":"testnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":$service,
        "errors":$errors,
        "node_id":"$node_id",
        "last_proof":"$last_proof"
  }
}
EOF

cat $json | jq
