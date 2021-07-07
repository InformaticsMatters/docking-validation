#!/bin/bash

set -e

rm -rf .nextflow* work
rm actives.* decoys.* ligands.* rdockconfig.as rdockconfig_cav1.grd receptor.* xtal-lig.*
rm -rf results_rdock results_smina_ad4 results_smina_dkoes results_smina_vina results_smina_vinardo

