#!/bin/bash
# run rDock for the docking


set -e


for f in NUDT7A-*_apo.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo.*}"
	echo "Running docking for $basename ..."
    docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock:2013.1 bash _3_run_rdock.sh $basename
done

