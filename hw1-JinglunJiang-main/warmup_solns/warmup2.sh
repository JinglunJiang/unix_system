#! /usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

echo "$@"

for argument in "$@"; do 
    CNET="$(echo "$argument" | cut -f 1 -d:)"
    POSITION="$(echo "$argument" | cut -f 2 -d:)"
    mkdir -p "$POSITION/$CNET"
done 
