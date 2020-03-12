#!/bin/bash

set -e

echo "Copying files ..."

cp ../../../../datasets/XChem/NUDT7/*/*.mol .
cp ../../../../datasets/XChem/NUDT7/*/*.pdb .

cp ../../../../scripts/select_points_SDF.pl .

echo "Files copied. Files are:"
ls *.mol *.pdb

echo "Creating SDF with all ligands ..."
ligands=ligands.sdf
rm -f $ligands
for f in *.mol
do
    echo ${f%.*} >> $ligands
    tail -n +2 $f >> $ligands
    echo '$$$$' >> $ligands
done
echo "$ligands created"

echo "Done"
