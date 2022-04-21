#!/bin/bash
GITHUB_TOKEN="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"
INPUT_STR=$(curl --header "Authorization: token $GITHUB_TOKEN" https://api.github.com/search/repositories?q=Schema+in:name+org:Dechea | jq -r '.items | map(.full_name) | join(",")')
GITHUB_REPOSITORY="Dechea/HES_Schema"
BRANCH_NAME_OTHERS="main"
BRANCH_NAME_MAIN="main"

result2="$GITHUB_REPOSITORY@$BRANCH_NAME_MAIN"
IFS="," read -a repoNames <<< $INPUT_STR
declare -a ARRAY_NAME=()

for index in "${!repoNames[@]}"
do
  if [ $GITHUB_REPOSITORY != ${repoNames[index]} ]
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
