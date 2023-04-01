#!/bin/bash

ORG="ZundereneWork"
TOKEN="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"
NAME="HOLA"
echo $ORG
echo $TOKEN
echo $NAME
# Configure the runner to connect to a GitHub organization
T=$(curl -X POST \
  'https://api.github.com/orgs/ZundereneWork/actions/runners/registration-token' \
  --header 'User-Agent: Thunder Client (https://www.thunderclient.com)' \
  --header 'Accept: application/vnd.github.v3+json' \
  --header 'Authorization: Bearer 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' | jq -r '.token')
echo $T
./config.sh --url https://github.com/$ORG --token $T --name $NAME --labels docker  --replace
./run.sh