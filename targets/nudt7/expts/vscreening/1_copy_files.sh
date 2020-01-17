#!/bin/bash

set -e

echo "Copying files ..."

cp ../../../../datasets/XChem/NUDT7/candidate-ligands.sdf.gz .
cp ../../../../datasets/XChem/NUDT7/*/*.mol .
cp ../../../../datasets/XChem/NUDT7/*/*.pdb .

echo "Files copied. Files are:"
ls candidate-ligands.sdf.gz *.mol *.pdb

echo "Done"
