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
  cp $f/receptor_apo-desolv.pdb $path/
  sed "s/@@BASENAME@@/$dir/g" docking-global.prm > $path/docking-global.prm
  sed "s/@@BASENAME@@/$dir/g" docking-local.prm > $path/docking-local.prm
  
  echo "Converting to mol2 format"
  docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/obabel:3.1.1 obabel $path/receptor_apo-desolv.pdb -O${path}/receptor_apo-desolv.mol2 -h
  
  cd $path
  rm -f receptor.pdb receptor.mol2
  ln -s receptor_apo-desolv.pdb receptor.pdb
  ln -s receptor_apo-desolv.mol2 receptor.mol2
  cd $basedir

  echo "Creating global cavity for $path"
  docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest\
    sh -c "cd $path; rbcavity -was -d -r docking-global.prm > rbcavity-global.log"

  echo "Creating local cavity for $path"
  docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest\
    sh -c "cd $path; rbcavity -was -d -r docking-local.prm > rbcavity-local.log"

  touch $path/pharma.restr
  
  
done
echo "Finished"
