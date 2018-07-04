#!/bin/bash

set -e

docker run -it --rm -v $PWD:/work:z -w /work -u $(id -u):$(id -g) informaticsmatters/rdock:latest bash _3_run_rdock.sh

