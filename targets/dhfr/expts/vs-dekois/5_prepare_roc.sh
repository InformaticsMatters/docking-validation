#!/bin/sh

set -e 

docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest bash _5_prepare_roc.sh


