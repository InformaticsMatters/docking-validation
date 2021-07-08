#!/bin/bash

set -e

echo Generating ROC curves

docker run -it --rm -v $PWD:/work -w /work -u $(id -u):$(id -g) informaticsmatters/vs-prep /code/calculate-roc-curves.py\
  --actives-file-name actives.txt -o ROC.png  -p1 results_rdock/results_1poseperlig.txt -l1 rDock\
  -p2 results_smina_vinardo/results_1poseperlig.txt -l2 vinardo\
  -p3 results_smina_vina/results_1poseperlig.txt -l3 vina\
  -p4 results_smina_dkoes/results_1poseperlig.txt -l4 dkoes\
  -p5 results_smina_ad4/results_1poseperlig.txt -l5 ad4

echo Done.
