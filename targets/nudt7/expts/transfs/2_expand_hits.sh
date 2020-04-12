#!/usr/bin/env bash

# This script is work in progress

if [ -z $KEYCLOAK_USERNAME ]
then
    echo "Must specify KEYCLOAK_USERNAME environment variable"
    exit 1
fi
if [ -z $KEYCLOAK_PASSWORD ]
then
    echo "Must specify KEYCLOAK_PASSWORD environment variable"
    exit 1
fi

token=$(curl -d "grant_type=password" -d "client_id=fragnet-search" -d "username=$KEYCLOAK_USERNAME" -d "password=$KEYCLOAK_PASSWORD"\
  https://squonk.it/auth/realms/squonk/protocol/openid-connect/token 2> /dev/null \
  | jq -r '.access_token')

echo "Expanding hits"history
curl -kL -H "Authorization: bearer $token" -H "Content-Type: chemical/x-mdl-sdfile" --data-binary "@hits.sdf" "https://fragnet-staging.informaticsmatters.org/fragnet-search/rest/v2/search/expand-multi?hac=5&rac=2&hops=2" > expanded.json


jq -r .results[].smiles expanded.json > expanded.smi

# sed 's/\(.*\)/\1 \1/' expanded.smi > expandedx2.smi

# obabel expandedx2.smi -o sdf -O expanded.sdf -p 7.4 --gen3D