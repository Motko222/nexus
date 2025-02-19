#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

sudo tee /etc/systemd/system/$folder.service > /dev/null <<EOF
[Unit]
Description=$folder
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=$path/start-cargo.sh
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $folder
