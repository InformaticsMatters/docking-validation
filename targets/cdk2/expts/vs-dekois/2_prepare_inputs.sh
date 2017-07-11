#!/bin/bash

docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel 1ckp_cdk2_without_ligand_prep_maestro.pdb -Ocdk2_protein.mol2
docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel ligand_1ckp_cdk2.mol2 -Oxtal-lig.sdf
