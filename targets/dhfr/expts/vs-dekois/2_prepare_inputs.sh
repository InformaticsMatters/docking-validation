#!/bin/bash

set -e

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) abradle/obabel obabel receptor.pdb -Oreceptor.mol2
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) abradle/obabel obabel xtal-lig.mol2 -Oxtal-lig.sdf
gunzip -c actives.sdf.gz decoys.sdf.gz | gzip > ligands.sdf.gz


