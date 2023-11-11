#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 1 || ! -f "./$1" ]]; then
  exit 1
fi

grep -o -P '([0-2][0-9]|3[0-1])/(0[0-9]|1[0-2])/\d{4}' "./$1" | cut -f3 -d'/' | grep -o -P '19\d{2}' | sort -n