#!/bin/bash

set -e

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep obabel receptor.pdb -O receptor.mol2
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep obabel xtal-lig.mol2 -O xtal-lig.mol
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep obabel actives.sdf.gz -O actives.sdf
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep obabel decoys.sdf.gz -O decoys.sdf
cat actives.sdf decoys.sdf > ligands.sdf
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep obabel ligands.sdf -O ligands.mol2
docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-rdock /bin/bash -c 'sdreport -c"" -nh actives.sdf | cut -f 2 -d "," > actives.txt'
