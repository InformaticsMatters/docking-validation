#!/bin/bash

for d in Mpro-x*
do
cd $d
cp ${d}_apo-desolv.pdb protein.pdb
pymol -cq ../alternate.pml
mv fixed.pdb ${d}_fixed.pdb
rm protein.pdb
cd ..
done 
