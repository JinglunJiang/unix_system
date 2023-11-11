#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

MAX_VALUE=0

if [[ $# -lt 0 ]]; then
  echo "Error: no numvers file entered"
  exit 1
fi

while read -r line; do
  if [[ MAX_VALUE -lt $line ]]; then
    MAX_VALUE=$line
  fi
done <"$1"

echo "$MAX_VALUE"


