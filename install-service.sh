#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')
source $path/env

sudo tee /etc/systemd/system/$folder.service > /dev/null <<EOF
[Unit]
Description=$folder
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=/root/nexus-cli/clients/cli/target/release/nexus-network start --headless --node-id $NODEID
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $folder
