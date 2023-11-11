#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -lt 1 ]]; then
  echo "Error: no numbers file entered"
  exit 1
fi

mkdir -p "logs"
for argument in "${@:2}"; do 
  while read -r line; do
    if [[ "$(echo "$line" | cut -f14 -d,)" == "$argument" ]]; then
      SUSER="$(echo "$line" | cut -f14 -d,)"
      DEVICE_PRODUCT="$(echo "$line" | cut -f2 -d,)"
      NAME="$(echo "$line" | cut -f6 -d,)"
      START="$(echo "$line" | cut -f7 -d,)"
      if [[ ! -d "logs/$SUSER/$DEVICE_PRODUCT" ]]; then
        mkdir -p "logs/$SUSER/$DEVICE_PRODUCT"
      fi
      if [[ -e "logs/$SUSER/$DEVICE_PRODUCT/log.csv" ]]; then
        echo "$START,$NAME" >> "logs/$SUSER/$DEVICE_PRODUCT/log.csv"
      else
        touch "logs/$SUSER/$DEVICE_PRODUCT/log.csv"
        echo "start,name" > "logs/$SUSER/$DEVICE_PRODUCT/log.csv"
        echo "$START,$NAME" >> "logs/$SUSER/$DEVICE_PRODUCT/log.csv"
      fi
    fi
  done <"$1"
done