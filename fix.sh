#!/bin/bash

source /root/.cargo/env
sudo apt remove -y protobuf-compiler 
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip 
unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local 
export PATH="/root/.local/bin:$PATH" 
protoc --version
cd /root/.nexus/network-api/clients/cli
rustup target add riscv32i-unknown-none-elf
apt install screen -y
