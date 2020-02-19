#!/bin/bash

set -e

echo "Copying files ..."

if [ ! -d xray ]; then mkdir xray; fi

for d in NUDT7A-x0129 NUDT7A-x0151 NUDT7A-x0254 NUDT7A-x0384 NUDT7A-x0389
do
	if [ ! -d xray/$d ]; then mkdir xray/$d; fi
done

cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0129/NUDT7A-*_apo.pdb xray/NUDT7A-x0129/receptor.pdb
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0151/NUDT7A-*_apo.pdb xray/NUDT7A-x0151/receptor.pdb
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0254/NUDT7A-*_apo.pdb xray/NUDT7A-x0254/receptor.pdb
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0384/NUDT7A-*_apo.pdb xray/NUDT7A-x0384/receptor.pdb
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0389/NUDT7A-*_apo.pdb xray/NUDT7A-x0389/receptor.pdb

cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0129/NUDT7A-*.mol xray/NUDT7A-x0129/ligand.mol
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0151/NUDT7A-*.mol xray/NUDT7A-x0151/ligand.mol
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0254/NUDT7A-*.mol xray/NUDT7A-x0254/ligand.mol
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0384/NUDT7A-*.mol xray/NUDT7A-x0384/ligand.mol
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0389/NUDT7A-*.mol xray/NUDT7A-x0389/ligand.mol



echo "Files copied. Files are:"
ls xray/*/*

echo "Done"
