#!/bin/bash
# runs rdock in each target directory

basedir=$PWD
for path in work/Mpro-*
do
	echo "Processing $path ..."
	cd $path
    nextflow -c ../../nextflow.config run ../../main.nf -with-docker -with-report -with-trace $@
    cd $basedir
done
