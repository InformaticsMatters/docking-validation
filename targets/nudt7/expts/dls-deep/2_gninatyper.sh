#!/bin/bash
# runs gninatyper to prepare the proteins and the docked poses

set -e

echo "Running gninatyper of proteins ..."

image='informaticsmatters/deep-app-ubuntu-1604:latest'
basedir=$PWD
for d in NUDT7A-x0129 NUDT7A-x0151 NUDT7A-x0254 NUDT7A-x0384 NUDT7A-x0389
do
    cd $d
	if [ ! -d gninatypes/protein ]; then mkdir -p gninatypes/protein; fi
	if [ ! -d gninatypes/ligands ]; then mkdir -p gninatypes/ligands; fi

    echo "Processing protein for $d ..."
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) $image gninatyper ${d}_apo.pdb gninatypes/protein/${d}.gninatypes

	echo "Processing ligands for $d ..."
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) $image gninatyper rdock-poses.sdf.gz gninatypes/ligands/ligand

    echo "Writing input definition file for $d ..."
    for f in gninatypes/ligands/ligand*.gninatypes
    do
        echo "1 work/gninatypes/protein/${d}.gninatypes work/${f}" >> gninatypes/input.types
    done
    cd $basedir
done

