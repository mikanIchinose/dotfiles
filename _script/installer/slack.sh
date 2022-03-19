#!/usr/bin/env bash
set -e

# load utility functions
DIR=$(dirname "$0")
cd "$DIR"
. ../utils/functions.sh

info "setup slack"

sudo snap install slack --classic

success "Finished"
