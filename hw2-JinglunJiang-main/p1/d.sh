#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 1 || ! -f "$1" ]]; then
  exit 1
fi

cat $1 | awk -F, '{ for (i = $1+96; i <= $2+96; i++) printf "%c ", i}'; echo " "