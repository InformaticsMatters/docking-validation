#!/bin/bash
# prepares the cavity defintion
 
docker run -it --rm -v $PWD:/work -w /work informaticsmatters/rdock rbcavity -was -d -r receptor.prm


