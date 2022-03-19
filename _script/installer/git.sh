#!/usr/bin/env bash

set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup git"

sudo add-apt-repository ppa:git-core/ppa
sudo apt update && sudo apt install -y git

git --version

success "Finished"
