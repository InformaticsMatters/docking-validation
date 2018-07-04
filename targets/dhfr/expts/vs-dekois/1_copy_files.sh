#!/bin/bash

set -e

cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/decoys/DHFR_Celling-v1.12_decoyset.sdf.gz decoys.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_library/ligands/DHFR.sdf.gz actives.sdf.gz
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_targets_prep/1s3v_DHFR_without_ligand_prep_maestro.pdb receptor.pdb
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_xtal_ligand/ligand_1s3v_DHFR.mol2 xtal-lig.mol2

echo "Copying complete"

