#!/bin/bash

source /root/.cargo/env
export PATH="/root/.local/bin:$PATH"
cd /root/.nexus/network-api/clients/cli
echo "y" | cargo run --release -- --start --beta
