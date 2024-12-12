#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

apt update && sudo apt upgrade
apt install curl build-essential pkg-config libssl-dev git-all -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh
source $HOME/.cargo/env
rustc --version
cargo --version

sudo tee /etc/systemd/system/$folder.service > /dev/null <<EOF
[Unit]
Description=$folder
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=curl https://cli.nexus.xyz/ | sh
Restart=always
RestartSec=30
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $folder
