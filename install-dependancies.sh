#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd)
folder=$(echo $path | awk -F/ '{print $NF}')

apt update && sudo apt upgrade
apt install curl build-essential pkg-config libssl-dev git-all protobuf-compiler -y
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh
source $HOME/.cargo/env
rustc --version
cargo --version
