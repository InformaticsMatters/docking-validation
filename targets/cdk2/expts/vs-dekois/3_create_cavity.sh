#!/bin/bash
# prepares the cavity defintion

set -e
 
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest rbcavity -was -d -r cdk2_rdock.prm


