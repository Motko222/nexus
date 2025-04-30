#!/bin/bash

source /root/.cargo/env
export PATH="/root/.local/bin:$PATH"
cd /root/.nexus/nexus-cli/clients/cli
echo "y" | cargo run --release -- start --env beta
