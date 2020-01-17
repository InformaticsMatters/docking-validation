#!/bin/bash
# runs rdock in each target directory


basedir=$PWD
basename=NUDT7A-x0129
cd $basename
nextflow -c ../nextflow.config run ../rdock.nf -with-docker $@
cd $basedir

