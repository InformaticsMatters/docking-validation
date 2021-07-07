#!/bin/sh

set -e 

docker run -it --rm -v $PWD:/work:Z -w /work -u $(id -u):$(id -g) informaticsmatters/vs-rdock:latest bash _6_prepare_roc.sh $@


