#!/bin/bash

set -e

docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) abradle/obabel obabel receptor.pdb -Oreceptor.mol2
docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) abradle/obabel obabel ligand.mol2 -Oligand.sdf


