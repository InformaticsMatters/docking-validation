#!/bin/bash
#
# remote execution of this workflow. Assumes you have password-less SSH set up.

set -e

PRM_FILE=cdk2_rdock.prm
PROTEIN_FILE=cdk2_rdock.mol2
LIGANDS_FILE=cdk2_ligprep.sdf.gz
AS_FILE=cdk2_rdock.as
NF_WORKFLOW=rdock.nf
NF_CONFIG=nextflow.config
NF_OPTS=$NF_OPTS
NF_REPORT='-with-report -with-trace'
RESULTS_FILE=rdock_results.sdf.gz
SERVER=diamond


MYTMP=$(ssh diamond mktemp -d --tmpdir=\$HOME/tmp)
echo "Created work dir of $MYTMP"

scp $PRM_FILE $PROTEIN_FILE $LIGANDS_FILE $AS_FILE $NF_WORKFLOW $NF_CONFIG $SERVER:$MYTMP

echo "Starting workflow execution using options $NF_OPTS $NF_REPORT"
ssh -o ServerAliveInterval=30 diamond "module load global/testcluster && cd $MYTMP && nextflow run -c $NF_CONFIG $NF_WORKFLOW $NF_OPTS $NF_REPORT"
echo "Workflow execution completed"

scp $SERVER:$MYTMP/\{$RESULTS_FILE,report.html,trace.txt\} .
ssh diamond rm -rf $MYTMP

echo "Results in $RESULTS_FILE"


