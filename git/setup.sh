#! /usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../utils/functions.sh

SOURCE="$(realpath -m .)"
DESTINATION="$(realpath -m ~)"

info "Configuring git..."

find . -name ".git*" | while read file_name; do
  file_name=$(basename $file_name)
  symlink "$SOURCE/$file_name" "$DESTINATION/$file_name"
done

success "Finished configuring git."
