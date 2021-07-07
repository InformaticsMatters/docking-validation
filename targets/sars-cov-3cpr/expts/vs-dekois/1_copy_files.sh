#!/bin/bash

set -e

cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/decoys/SARS-HCoV_Celling-v1.12_decoyset.sdf.gz decoys.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/ligands/SARS-HCoV.sdf.gz actives.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_targets_prep/2Z94_SARS-HCoV_without_ligand_prep_maestro.pdb receptor.pdb
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_xtal_ligand/ligand_2z94_sars_hcov.mol2 xtal-lig.mol2

echo "Copying complete"

