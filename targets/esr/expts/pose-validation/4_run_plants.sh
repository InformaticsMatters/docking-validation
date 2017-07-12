#!/bin/bash

echo "Generating ligand in MOL2 format"
cat 1sj0_ligand.sd | docker run -i --rm -v $PWD:/work -w /work abradle/obabel obabel -i sdf -o mol2 -O 1sj0_ligand.mol2


echo "Running PLANTS ..."
rm -rf results_plants
docker run -it --rm -v $PWD:/work -w /work informaticsmatters/plants plants --mode screen plantsconfig
echo "Generating RMSDs"
docker run -it --rm -v $PWD:/work -w /work abradle/obabel obabel -i mol2 results_plants/LIGAND_entry_00001_conf_??.mol2 -o sdf -O results_plants/all_results.sdf
docker run -it --rm -v $PWD:/work -w /work informaticsmatters/rdock sdrmsd 1sj0_ligand.sd results_plants/all_results.sdf > plants.rmsd
echo "Done"

