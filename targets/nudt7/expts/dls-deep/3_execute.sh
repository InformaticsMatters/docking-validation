#!/usr/bin/env bash

set -e

echo "Running predictions for ligands ..."

image='informaticsmatters/deep-app-ubuntu-1604:latest'
basedir=$PWD
for d in NUDT7A-x0129 NUDT7A-x0151 NUDT7A-x0254 NUDT7A-x0384 NUDT7A-x0389
do
    cd $d
	echo "Processing $d ... in $PWD"
	if [ ! -d output ]; then mkdir output; fi

	docker run -it --rm --gpus all -v $PWD:/root/train/fragalysis_test_files/work:z $image\
	    bash -c "python3 scripts/predict.py -m resources/dense.prototxt -w resources/weights.caffemodel -i work/gninatypes/input.types >> work/output/predictions.txt"

    cd $basedir
done