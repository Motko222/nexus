#!/bin/bash

source /root/.cargo/env
cd /root/.nexus/network-api/clients/cli
cargo run --release -- --start --beta
