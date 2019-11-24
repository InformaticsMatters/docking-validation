#!/bin/bash
# runs rdock in each target directory


basedir=$PWD
for f in NUDT7A-*_apo.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo.*}"
	cd $basename
    nextflow -c ../nextflow.config run ../rdock.nf -with-docker
    cd $basedir
done