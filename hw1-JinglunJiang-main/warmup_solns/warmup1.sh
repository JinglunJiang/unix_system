#! /usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

MAX_VAR=-1

if [ $# -lt 1 ]; then
    echo "Error: no numbers file entered"
    exit 1
fi 

while read -r line; do
    if [[ $MAX_VAR -lt $line ]]; then 
        MAX_VAR=$line
    fi 
done<"$1"

echo "$MAX_VAR"
