#!/bin/bash
# prepares the cavity definition


basedir=$PWD
for f in NUDT7A-*_apo.pdb
do
	echo "Processing $f ..."
	basename="${f%_apo.*}"
	if [ ! -d $basename ]; then mkdir $basename; fi
	sed "s/@@BASENAME@@/$basename/g" template.prm > $basename/docking.prm
	ln -s ${basedir}/${basename}.mol ${basedir}/${basename}/ligand.mol
	echo "Creating ${basename}.mol2"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) abradle/obabel obabel $f -O${basename}/receptor.mol2
	echo "Creating cavity for $basename"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest sh -c "cd $basename; rbcavity -was -d -r docking.prm > rbcavity.log"
done

