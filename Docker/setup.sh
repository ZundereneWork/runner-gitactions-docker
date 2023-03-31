#!/bin/bash
# Configure the runner to connect to a GitHub organization
TOKEN=$(curl -X POST -H "Authorization: Bearer  $2" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/orgs/$1/actions/runners/registration-token \
    | jq -r '.token')
    
    
./config.sh remove --token $TOKEN
./config.sh --url https://github.com/$1 --token $TOKEN --name $3 --labels docker  --replace
./run.sh

