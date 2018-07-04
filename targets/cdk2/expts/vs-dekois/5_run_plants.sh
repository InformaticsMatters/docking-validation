#!/bin/bash

set -e

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/plants:latest plants --mode screen plantsconfig

