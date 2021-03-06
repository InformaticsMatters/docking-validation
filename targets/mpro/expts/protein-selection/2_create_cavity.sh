#!/bin/bash
# prepares the cavity defintion
# Uses a "Frankenstein" ligand comprised of all that atoms of the ligands that contribute to the surface of the
# fragment ligands combined into a single pseudo-molecule.

set -e

echo "Creating Frankenstein ligand ..."
docker run --rm -v $PWD:$PWD:Z -w $PWD perl:5 perl select_points_SDF.pl ligands.sdf > ligands_frankenstein.sdf

basedir=$PWD
for f in Mpro-*_apo-desolv.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo-desolv.*}"
	if [ ! -d $basename ]; then mkdir $basename; fi
	sed "s/@@BASENAME@@/$basename/g" template.prm > $basename/docking.prm
	echo "Creating ${basename}.mol2"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/obabel:3.0.0 obabel $f -O${basename}/receptor.mol2
	echo "Creating cavity for $basename"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest sh -c "cd $basename; rbcavity -was -d -r docking.prm > rbcavity.log"
done

