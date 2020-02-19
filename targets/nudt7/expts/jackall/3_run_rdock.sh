#!/bin/bash
# runs rdock in each target directory

basedir=$PWD
for path in work/NUDT7A-*
do
	echo "Processing $path ..."
	cd $path
    nextflow -c ../../nextflow.config run ../../rdock.nf -with-docker $@
    cd $basedir
done