#!/bin/bash
# prepares the cavity defintion
#
# Execute this sfile directly if singularity is present or submit to SGE like this:
# qsub -sync y 2_create_cavity.sh

set -e

singularity exec ~/singularity-containers/rdock-mini-latest.simg rbcavity -was -d -r cdk2_rdock.prm

