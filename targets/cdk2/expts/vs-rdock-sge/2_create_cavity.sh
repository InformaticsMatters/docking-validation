#!/bin/bash
# prepares the cavity defintion

set -e
 
qsub -sync y -b y singularity exec ~/singularity-containers/rdock-mini-latest.simg rbcavity -was -d -r cdk2_rdock.prm


