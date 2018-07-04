#!/bin/bash

set -e

echo Generating ROC curves

docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) informaticsmatters/r-roc R -f _6_generate_roc.r

echo Done.
