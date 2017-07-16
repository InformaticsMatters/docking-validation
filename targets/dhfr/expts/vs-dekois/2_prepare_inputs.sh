#!/bin/bash

docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel receptor.pdb -Oreceptor.mol2
docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel xtal-lig.mol2 -Oxtal-lig.sdf
gunzip -c actives.sdf.gz decoys.sdf.gz | gzip > ligands.sdf.gz


