#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ ($# -ne 3) || ("$1" != *.csv) ]]; then
  echo "error: incorrect command line arguments"
  echo "usage p1.sh FILE WARD SECTION"
  exit 1
fi

MAX_WARD=$(cat "$1" | tail -n +2 | cut -f2 -d, | sort | tail -n 1)
MIN_WARD=$(cat "$1" | cut -f2 -d, | sort -r | tail -n 1)
MAX_SECTION=$(cat "$1" | tail -n +2| cut -f3 -d, | sort | tail -n 1)
MIN_SECTION=$(cat "$1" | cut -f3 -d, | sort -r | tail -n 1)

if [[ ($2 -lt MIN_WARD) || ($2 -gt MAX_WARD) || ($3 -lt MIN_SECTION) || ($3 -gt MAX_SECTION) ]]; then
  echo "error: incorrect command line arguments"
  echo "usage p1.sh FILE WARD SECTION"
  exit 1
fi

WARDSECTION=$(printf "%02d%02d" $2 $3)

WARDSCHED=$(grep "$WARDSECTION" "$1" | cut -f5- -d, | sort -n)

while read -r line; do
  MONTH="$(echo "$line" | cut -f1 -d,)"
  DAYS="$(echo "$line" | cut -f2 -d'"'| tr "," "\n")"
  for DAY in $DAYS; do
    echo "$(printf "%02d/%02d/23" "$MONTH" "$DAY")"
  done
done <<<"$WARDSCHED"

