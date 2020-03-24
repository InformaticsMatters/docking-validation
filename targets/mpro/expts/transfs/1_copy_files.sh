#!/bin/bash

set -e

echo "Copying files ..."

cp ../../../../scripts/select_points_SDF.pl .

if [ ! -d xray ]; then mkdir xray; fi

for p in ../../../../datasets/XChem/MPRO/*
do
    d=$(echo $p | cut -d '/' -f8)
    echo "Using dir $d"
	if [ ! -d xray/$d ]; then mkdir xray/$d; fi
	cp ../../../../datasets/XChem/MPRO/$d/${d}_apo-desolv.pdb xray/$d/receptor.pdb
	cp ../../../../datasets/XChem/MPRO/$d/${d}_apo.pdb xray/$d/receptor-solv.pdb
	cp ../../../../datasets/XChem/MPRO/$d/${d}.mol xray/$d/ligand.mol
done


rm -f hits.sdf
for f in xray/*/ligand.mol
do
    dir=$(echo $f | cut -d '/' -f2)
    echo $dir >> hits.sdf
    tail -n +2 $f >> hits.sdf
    echo '$$$$' >> hits.sdf
done

echo "Files copied. Files are:"
ls xray/*/*

echo "Done"
