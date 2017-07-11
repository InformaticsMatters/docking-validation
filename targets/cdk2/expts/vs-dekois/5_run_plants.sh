#!/bin/bash

docker run -it --rm -v $PWD:/work -w /work informaticsmatters/plants plants --mode screen plantsconfig

