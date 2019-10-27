#!/bin/bash

set -e

echo "Copying files ..."

cp ../../../../datasets/XChem/NUDT7/*/*.mol .
cp ../../../../datasets/XChem/NUDT7/*/*.pdb .

echo "Files copied. Files are:"
ls *.mol *.pdb

echo "Done"
