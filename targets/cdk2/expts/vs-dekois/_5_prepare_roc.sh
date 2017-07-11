#!/bin/sh

echo 'Creating lists...'
gunzip -c CDK2.sdf.gz | sdreport -c"" -nh | cut -f 2 -d "," > ligands.txt

echo Filtering results ...
gunzip -c rdock_results.sdf.gz | sdsort -n -s -fSCORE | sdfilter -f'$_COUNT == 1' | gzip >  rdock_results_1poseperlig.sdf.gz

echo Preparing data for R ...
gunzip -c rdock_results_1poseperlig.sdf.gz | sdreport -t | awk '{print $2,$3,$4,$5,$6,$7}' > rdock_dataforR_uq.txt

echo Done

