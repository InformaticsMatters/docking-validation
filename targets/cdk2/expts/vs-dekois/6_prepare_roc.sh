#!/bin/sh

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock-mini:latest bash _6_prepare_roc.sh


