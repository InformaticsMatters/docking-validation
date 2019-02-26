#!/bin/bash

ZIP_FILE=config.zip
NF_WORKFLOW=main.nf
NF_OPTS='--chunk 4 --limit 40 --num_dockings 8'
NF_REPORT='-with-report -with-trace'
NF_INIT=${NF_INIT_SCRIPT:-$HOME/nextflow-init.sh}

echo "Looking for init script $NF_INIT"
if [ -f $NF_INIT ]; then
    echo "Executing init script"
    source $NF_INIT
fi

echo "Unzipping docking configuration"
unzip -o $ZIP_FILE

echo "Running Nextflow"
nextflow run $NF_WORKFLOW $NF_OPTS $NF_REPORT
echo 'Nextflow completed'
