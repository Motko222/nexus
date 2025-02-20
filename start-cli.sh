#!/bin/bash

source /root/.cargo/env
export PATH="/root/.local/bin:$PATH"
curl https://cli.nexus.xyz/ | sh
