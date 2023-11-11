#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 1 || ! -f "./$1" ]]; then
  exit 1
fi

grep -o -P '\(\d{3}-\d{3}-\d{4}\)' "./$1" | wc -l