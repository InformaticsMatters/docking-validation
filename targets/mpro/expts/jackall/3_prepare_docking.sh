#!/bin/bash
# prepares the inputs and cavity definition

basedir=$PWD


echo "Creating Frankenstein ligand ..."
docker run --rm -v $PWD:$PWD:Z -w $PWD perl:5 perl select_points_SDF.pl hits.sdf > hits_frankenstein.sdf

for f in xray/*
do
	echo "Processing $f ..."
	dir=$(echo $f | cut -d '/' -f2)
	path=work/$dir

	if [ ! -d $path ]; then mkdir -p $path; fi
	cp $f/ligand.mol $path
	cp hits_frankenstein.sdf $path
	cp $f/receptor-solv.pdb $path/receptor-solv.pdb
	cp $f/receptor.pdb $path/receptor-nosolv.pdb
	sed "s/@@BASENAME@@/$dir/g" frankenstein.prm > $path/docking-global.prm
	sed "s/@@BASENAME@@/$dir/g" template.prm > $path/docking-local.prm
	echo "Creating ${basename}.mol2"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/obabel:3.0.0 obabel $f/receptor.pdb -O${path}/receptor.mol2
	echo "Creating local cavity for $path"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest sh -c "cd $path; rbcavity -was -d -r docking-local.prm > rbcavity-local.log"
    echo "Creating global cavity for $path"
	docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest sh -c "cd $path; rbcavity -was -d -r docking-global.prm > rbcavity-global.log"

done


