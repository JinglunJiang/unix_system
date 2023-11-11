#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -ne 1 || ! -f "$1" ]]; then
  exit 1
fi

paste <(eval "echo Homework hw{1..$(cat "$1" | cut -f1 -d,)} | sed 's/ /\n/g'") \
      <(eval "echo Projects proj{1..$(cat "$1" | cut -f2 -d,)} | sed 's/ /\n/g'") \
      <(eval "echo Exams exam{1..$(cat "$1" | cut -f3 -d,)} | sed 's/ /\n/g'") | column -t


