#!/bin/bash

set -e

cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/decoys/CDK2_Celling-v1.12_decoyset.sdf.gz decoys.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/ligands/CDK2.sdf.gz actives.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_targets_prep/1ckp_cdk2_without_ligand_prep_maestro.pdb receptor.pdb
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_xtal_ligand/ligand_1ckp_cdk2.mol2 xtal-lig.mol2

echo "Copying complete"

