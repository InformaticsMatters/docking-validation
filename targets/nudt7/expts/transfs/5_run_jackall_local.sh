#!/bin/bash
# runs rdock in each target directory

basedir=$PWD
for path in work/NUDT7A-*
do
	echo "Processing $path ..."
	cd $path
    nextflow -c ../../nextflow.config run ../../../../../../scripts/transfs/transfs.nf -with-docker -with-report -with-trace --prmfile docking-local.prm --asfile docking-local.as $@
    cd $basedir
done