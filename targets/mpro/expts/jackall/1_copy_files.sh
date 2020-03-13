#!/bin/bash

set -e

echo "Copying files ..."

cp ../../../../scripts/select_points_SDF.pl .

if [ ! -d xray ]; then mkdir xray; fi

for d in Mpro-x0072_0 Mpro-x0104_0 Mpro-x0161_0 Mpro-x0195_0 Mpro-x0305_0 Mpro-x0434_0 Mpro-x0678_0
do
	if [ ! -d xray/$d ]; then mkdir xray/$d; fi
	cp ../../../../datasets/XChem/MPRO/$d/${d}_apo-desolv.pdb xray/$d/receptor.pdb
	cp ../../../../datasets/XChem/MPRO/$d/${d}_apo.pdb xray/$d/receptor-solv.pdb
	cp ../../../../datasets/XChem/MPRO/$d/${d}.mol xray/$d/ligand.mol
done


rm -f hits.sdf
for f in xray/*/ligand.mol
do
    cat $f >> hits.sdf
    echo '$$$$' >> hits.sdf
done

echo "Files copied. Files are:"
ls xray/*/*

echo "Done"
