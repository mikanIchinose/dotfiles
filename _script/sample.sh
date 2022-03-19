#! /usr/bin/env bash
# シンボリックリンクの作成

set -e

DIR=$(dirname "$0")
cd "$DIR"

# load util function
. ./utils/functions.sh

cd ../
SOURCE="$(realpath -m .)"
DESTINATION="$(realpath -m ~)"

echo $SOURCE
echo $DESTINATION
