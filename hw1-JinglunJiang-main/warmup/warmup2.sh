#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

for argument in $@; do
  CNET="$(echo "$argument" | cut -f1 -d:)"
  POSITION="$(echo "$argument" | cut -f2 -d:)"
  mkdir -p "$POSITION/CNET"
done
