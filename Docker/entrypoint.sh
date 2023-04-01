#!/bin/bash

echo $ORG
echo $TOKEN
echo $NAME

# Configure the runner to connect to a GitHub organization
TOKEN=$(curl -X POST -H "Authorization: Bearer  $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/orgs/$ORG/actions/runners/registration-token \
    | jq -r '.token')
    
echo $TOKEN 
./config.sh remove --token $TOKEN
./config.sh --url https://github.com/$ORG --token $TOKEN --name $NAME --labels docker  --replace
./run.sh

