#!/bin/bash

echo Generating ROC curves

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/r-roc:latest R -f _7_generate_roc.r

echo Done.
