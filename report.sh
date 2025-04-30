#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
json=~/logs/report-$folder
source ~/.bash_profile

version=$(cat /root/.nexus/nexus-cli/clients/cli/Cargo.toml | grep version | head -1 | awk '{print $NF}' | sed 's/\"//g')
service=$(sudo systemctl status $folder --no-pager | grep "active (running)" | wc -l)
errors=$(journalctl -u $folder.service --since "1 day ago" --no-hostname -o cat | grep -c -E "rror|ERR")
node_id=$(cat /root/.nexus/config.json | jq -r .node_id)
success=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c "Proving succeeded")
fetch=$(journalctl -u $folder.service --since "1 hour ago" --no-hostname -o cat | grep -c "Fetching a task to prove")



status="ok";message="proofs=$success/$fetch";
[ $errors -gt 100 ] && status="warning" && message="errors=$errors proofs=$success/$fetch";
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
        "chain":"devnet",
        "network":"testnet",
        "version":"$version",
        "status":"$status",
        "message":"$message",
        "service":$service,
        "errors":$errors,
        "node_id":"$node_id",
        "fetch":"$fetch",
        "submit":"$submit",
        "success":"$success"
  }
}
EOF

cat $json | jq
