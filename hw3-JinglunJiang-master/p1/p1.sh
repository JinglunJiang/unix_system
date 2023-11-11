#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

declare -A DICT # To store the command options

DICT["NUM_LINES"]=10
DICT["EXCLUDED_USERS"]=""
DICT["COMMAND"]="" #default values for number of lines, exclude users, and command to be selected

process_options(){
  while [ "$#" -gt 1 ]; do # as the file will always come to the last >1 will skip the argument for the file
    if [[ "$1" == "-n" ]]; then
      DICT["NUM_LINES"]="$2"
      shift 2
    elif [[ "$1" == "-p" ]]; then
      DICT["COMMAND"]="$2"
      shift 2
    elif [[ "$1" == "-e" ]]; then
      DICT["EXCLUDED_USERS"]="$(echo "$2" | tr ',' '\n')"
      shift 2
    fi
  done
}

process_options "$@"

CONTENTS=""
if [ $# -gt 0 ] && [ -f "${!#}" ]; then
    # If there are command-line arguments, use the last one as the input file
    INPUT_FILE="${!#}" #get the last argument
else
    # If no arguments, default to /dev/stdin
    INPUT_FILE="/dev/stdin"
fi

while read line; do
  CONTENTS+="$line\n"
done < "$INPUT_FILE"

RESULT="$(echo -e "$CONTENTS" | tr -s ' ' | tail -n +2 | cut -f1,11- -d' ')" #filter out the useless columns, only usernames and command names left

if [[ -n "${DICT["COMMAND"]}" ]]; then
  RESULT="$(echo -e "$RESULT" | grep -F "${DICT["COMMAND"]}" )" # first process the command and excluded users, the sequence doesn't matter
fi

RESULT="$(echo -e "$RESULT" | cut -f1 -d' ')" # cut the "command" column out after processing that column


if [[ -n "${DICT["EXCLUDED_USERS"]}" ]]; then
  RESULT="$(echo -e "$RESULT" | grep -v -w "${DICT["EXCLUDED_USERS"]}")"
fi

OUTPUT=$(echo -e "$RESULT" | sort | uniq -c | sort -k1,1nr -k2,2 | head -n "${DICT["NUM_LINES"]}")


while read -r line; do
  USER_PRECESSES=($line)
  echo -e "${USER_PRECESSES[1]},${USER_PRECESSES[0]}"
done <<< "$OUTPUT"