#!/bin/bash

sudo service docker start

# Configure the runner to connect to a GitHub organization
T=$(curl -X POST \
  "https://api.github.com/orgs/$ORG/actions/runners/registration-token" \
  --header 'User-Agent: Thunder Client (https://www.thunderclient.com)' \
  --header "Authorization: Bearer $TOKEN " | jq -r '.token')
./config.sh --url https://github.com/${ORG} --token ${T} --name ${NAME} --labels docker  --replace
./run.sh