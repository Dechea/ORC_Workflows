#!/bin/bash
INPUT_STR=$(curl --header "Authorization: token $1" https://api.github.com/search/repositories?q=Schema+in:name+org:Dechea | jq -r '.items | map(.full_name) | join(",")')
BRANCH_NAME_OTHERS="main"

result2="$2@$3"
IFS="," read -a repoNames <<< $INPUT_STR
declare -a ARRAY_NAME=()

for index in "${!repoNames[@]}"
do
  if [ $2 != ${repoNames[index]} ]
  then
    ARRAY_NAME+=(${repoNames[index]})
  fi
done

ARRAY_NAME=( "${ARRAY_NAME[@]/%/@$BRANCH_NAME_OTHERS}" )

if [ -z "$ARRAY_NAME" ]
then
  echo "$result2"
else
  result1=$(IFS=,; echo "${ARRAY_NAME[*]}")
  echo "$result1,$result2"
fi
