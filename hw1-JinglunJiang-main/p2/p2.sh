#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -lt 1 || ! -f "./$1" ]]; then
  exit 1
fi

mkdir -p "home"

while read -r line; do
  USERNAME="$( echo "$line" | cut -f1 -d' ' )"
  CLASS_CAT="$( echo "$line" | cut -f2 -d' ')"
  COURSE_ID="$( echo "$line" | cut -f3 -d' ')"
  GRADE="$( echo "$line" | cut -f4 -d' ')"
  cd "./home"
  mkdir -p "$USERNAME/$CLASS_CAT"
  cd "$USERNAME/$CLASS_CAT"
  touch "MPCS$COURSE_ID.txt"
  echo "$GRADE" > "MPCS$COURSE_ID.txt"
  cd "../../../"
done <"$1"