#!/bin/bash

set -e

echo "Running rbcavity"
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest rbcavity -r 1sj0_rdock.prm -was > 1sj0_cavity.log
echo "Done"

