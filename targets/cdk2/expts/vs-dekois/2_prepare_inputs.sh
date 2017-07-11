#!/bin/bash

docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel 1ckp_cdk2_without_ligand_prep_maestro.pdb -Ocdk2_protein.mol2
docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel ligand_1ckp_cdk2.mol2 -Oxtal-lig.sdf

# this is the input for plants
 gunzip -c CDK2.sdf.gz CDK2_Celling-v1.12_decoyset.sdf.gz | docker run -i --rm -v $PWD:/work -w /work abradle/obabel obabel -i sdf -o mol2 -O ligands.mol2

