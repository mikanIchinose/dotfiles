#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dollar to Yen
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 💰
# @raycast.argument1 { "type": "text", "placeholder": "dollar" }

# Documentation:
# @raycast.author mikan.ichinose
# @raycast.authorURL https://github.com/mikanIchinose

set -e
~/.cargo/bin/rates "$1" usd to jpy
