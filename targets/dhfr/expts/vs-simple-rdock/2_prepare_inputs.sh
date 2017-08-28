#!/bin/bash

docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel receptor.pdb -Oreceptor.mol2
docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel ligand.mol2 -Oligand.sdf


