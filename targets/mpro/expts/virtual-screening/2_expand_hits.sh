#!/bin/bash

# prior to running set the KEYCLOAK_TOKEN environment variable like this:
# export KEYCLOAK_TOKEN=$(curl -d "grant_type=password" -d "client_id=fragnet-search" \
#   -d "username=<username>" -d "password=<password>" \
#   https://keycloak.informaticsmatters.org/auth/realms/squonk/protocol/openid-connect/token 2> /dev/null | jq -r '.access_token')

docker run -t -v $PWD:$PWD:Z -w $PWD -u $(id -u):$(id -g) informaticsmatters/rdkit_pipelines python -m pipelines.xchem.fragnet_expand -i hits.sdf --token $KEYCLOAK_TOKEN --hac-min 0 --hac-max 8 --rac-min 0 --rac-max 8 --hops 2
