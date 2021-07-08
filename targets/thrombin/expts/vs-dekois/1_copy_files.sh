#!/bin/bash

set -e

cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/decoys/Thrombin_Celling-v1.12_decoyset.sdf.gz decoys.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/ligands/Thrombin.sdf.gz actives.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_targets_prep/3rm2_thrombin_without_ligand_prep_maestro.pdb receptor.pdb
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_xtal_ligand/ligand_3rm2_thrombin.mol2 xtal-lig.mol2

echo "Copying complete"

