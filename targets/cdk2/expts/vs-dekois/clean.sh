#!/bin/bash

rm -f 1ckp_cdk2_without_ligand_prep_maestro.pdb CDK2_Celling-v1.12_decoyset.sdf.gz CDK2.sdf.gz ligand_1ckp_cdk2.mol2 cdk2_protein.mol2
rm -f cdk2_rdock_cav1.grd cdk2_rdock.as protein.mol2 xtal-lig.sdf rdock_results.sdf.gz .nextflow.log*
rm -f actives.txt rdock_results_1poseperlig.sdf.gz rdock_dataforR_uq.txt cdk2_rdock_ROC.jpg
rm -rf work results_plants
