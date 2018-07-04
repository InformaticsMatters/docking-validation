#!/bin/bash
# prepares the cavity defintion
 
docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini rbcavity -was -d -r receptor.prm


