#!/bin/bash

set -e

NF_REPORT='-with-trace results/trace.txt'
NF_INIT=${NF_INIT_SCRIPT:-$HOME/nextflow-init.sh}

echo "Looking for init script $NF_INIT"
if [ -f $NF_INIT ]; then
    echo "Executing init script"
    source $NF_INIT
fi

echo "Running Nextflow"
nextflow run main.nf $NF_REPORT
echo "Nextflow completed $?"
