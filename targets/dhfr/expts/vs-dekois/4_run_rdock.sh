#!/bin/bash
# runs rdock. 
# For smaller test runs adjust the limit, chunk and num_dockings parameters. e.g.
# nextflow run rdock.nf --limit 100 --chunk 5 --num_dockings 1 -with-docker busybox
 
nextflow run rdock.nf -with-docker busybox

