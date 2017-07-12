#!/bin/bash

echo "Running rbcavity"
docker run -it --rm -v $PWD:/work -w /work informaticsmatters/rdock rbcavity -r 1sj0_rdock.prm -was > 1sj0_cavity.log
echo "Done"

