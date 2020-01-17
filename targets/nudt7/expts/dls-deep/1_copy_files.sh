#!/bin/bash

set -e

echo "Copying files ..."

for d in NUDT7A-x0129 NUDT7A-x0151 NUDT7A-x0254 NUDT7A-x0384 NUDT7A-x0389
do
	if [ ! -d $d ]; then mkdir $d; fi
done

cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0129/NUDT7A-*_apo.pdb NUDT7A-x0129/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0151/NUDT7A-*_apo.pdb NUDT7A-x0151/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0254/NUDT7A-*_apo.pdb NUDT7A-x0254/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0384/NUDT7A-*_apo.pdb NUDT7A-x0384/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0389/NUDT7A-*_apo.pdb NUDT7A-x0389/

cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0129/rdock-poses.sdf.gz NUDT7A-x0129/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0151/rdock-poses.sdf.gz NUDT7A-x0151/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0254/rdock-poses.sdf.gz NUDT7A-x0254/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0384/rdock-poses.sdf.gz NUDT7A-x0384/
cp ../../../../datasets/XChem/NUDT7/NUDT7A-x0389/rdock-poses.sdf.gz NUDT7A-x0389/

echo "Files copied. Files are:"
ls */NUDT7A-*.pdb NUDT7A-*/rdock-poses.sdf.gz

echo "Done"
