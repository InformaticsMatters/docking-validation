#!/bin/bash

rm -f decoys.sdf.gz actives.sdf.gz receptor.* ligands.* xtal-lig.* 
rm -f rdockconfig.grd rdockconfig.as rdockconfig_cav1.grd rdock_results.sdf.gz .nextflow.log*
rm -f actives.txt rdock_results_1poseperlig.sdf.gz rdock_dataforR_uq.txt rdock_ROC.jpg
rm -rf work
