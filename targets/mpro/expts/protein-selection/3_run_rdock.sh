#!/bin/bash
# run rDock for the docking


set -e


for f in Mpro-*_apo-desolv.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo-desolv.*}"
	echo "Running docking for $basename ..."
    docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock:latest bash _3_run_rdock.sh $basename
done

