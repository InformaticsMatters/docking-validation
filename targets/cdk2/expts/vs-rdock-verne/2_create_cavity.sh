#!/bin/bash
# prepares the cavity defintion

set -e
 
singularity exec $NXF_SINGULARITY_CACHEDIR/rdock-mini-latest.simg rbcavity -was -d -r cdk2_rdock.prm


