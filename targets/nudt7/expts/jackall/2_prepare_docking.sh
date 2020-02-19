#!/bin/bash
# prepares the inputs and cavity definition

basedir=$PWD
for f in xray/*
do
	echo "Processing $f ..."
	dir=$(echo $f | cut -d '/' -f2)
	path=work/$dir

	if [ ! -d $path ]; then mkdir -p $path; fi
	cp $f/ligand.mol $path
	sed "s/@@BASENAME@@/$dir/g" template.prm > $path/docking.prm
	echo "Creating ${basename}.mol2"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/obabel:3.0.0 obabel xray/$dir/receptor.pdb -O${path}/receptor.mol2
	echo "Creating cavity for $basename"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest sh -c "cd $path; rbcavity -was -d -r docking.prm > rbcavity.log"
done

# TODO prepare the cavity for the frankenstein ligand

