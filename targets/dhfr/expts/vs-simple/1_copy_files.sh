#!/bin/bash

cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_targets_prep/1s3v_DHFR_without_ligand_prep_maestro.pdb receptor.pdb
cp ../../../../datasets/DEKOIS_2.0/DEKOIS_targets/final_xtal_ligand/ligand_1s3v_DHFR.mol2 ligand.mol2
cp ../../../../datasets/sutherland/dhfr_3d.sdf.gz ligands.sdf.gz

echo "Copying complete"

