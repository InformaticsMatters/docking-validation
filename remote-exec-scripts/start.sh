#!/bin/bash

set -e

NF_REPORT='-with-trace -with-report -with-timeline'
NF_INIT=${NF_INIT_SCRIPT:-$HOME/nextflow-init.sh}
NF_COMPLETE=${NF_INIT_SCRIPT:-$HOME/nextflow-complete.sh}

echo "Looking for init script $NF_INIT"
if [ -f $NF_INIT ]; then
    echo "Executing init script"
    source $NF_INIT
fi

echo "Running Nextflow"
nextflow run main.nf $NF_REPORT
echo "Nextflow completed $?"

echo "Looking for completion script $NF_COMPLETE"
if [ -f $NF_COMPLETE ]; then
    echo "Executing completion script"
    $NF_COMPLETE $PWD
fi
