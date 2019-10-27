#!/bin/bash
# runs rdock. 
# For smaller test runs adjust the limit, chunk and num_dockings parameters. e.g.
# nextflow run rdock.nf --limit 100 --chunk 5 --num_dockings 1 -with-docker


basedir=$PWD
for f in NUDT7A-*_apo.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo.*}"
	cd $basename
    nextflow -c ../nextflow.config run ../rdock.nf -with-docker
    cd $basedir
done