#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -gt 1 ]]; then
  exit 1
fi

PROCESS_DATA(){
    tail -n +2 "./lstops.csv" | while read -r line; do
      STOP=$(echo "$line" | grep -oP ',\K["]?[^,]+(?= \()' | sed 's/"//g')
      if grep -oP '\([A-Za-z]+ Line' <<< "$line"; then
        BUS=$(echo "$line" | grep -oP '\([A-Za-z]+[^/s]' | sed 's/(//g')
        echo "$STOP,$BUS"
       
      else
        BUSES="$(echo "$line" | grep -oP '\([A-Za-z, &]+lines' | sed 's/(//g' | tr " &" "\n" | tr " , " "\n" | sed 's/lines//g')"
        for BUS in $BUSES; do
          echo "$STOP,$BUS"
        done
      fi
    done
}

if [[ $# -eq 1 && ( "$1" == "red" || "$1" == "blue" || "$1" == "brown" || "$1" == "green" || "$1" == "orange" || "$1" == "pink" || "$1" == "purple" || "$1" == "yellow" ) ]]; then
  FIRST_CHAR=$(echo "$1" | cut -c 1 | tr '[:lower:]' '[:upper:]')
  ARGUMENT="$FIRST_CHAR$(echo "$1" | cut -c 2-)"
  PROCESS_DATA | grep ",$ARGUMENT" | sort | uniq
elif [[ $# -eq 0 ]]; then
  PROCESS_DATA | sort | uniq
else
  exit 1
fi