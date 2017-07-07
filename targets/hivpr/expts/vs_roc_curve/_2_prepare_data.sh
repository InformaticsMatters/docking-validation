#!/bin/bash

echo Filtering results ...
gunzip -c hivpr_all_results.sd.gz | sdsort -n -s -fSCORE | sdfilter -f'$_COUNT == 1' | gzip >  hivpr_1poseperlig.sdf.gz

echo Preparing data for R ...
gunzip -c hivpr_1poseperlig.sdf.gz | sdreport -t | awk '{print $2,$3,$4,$5,$6,$7}' > dataforR_uq.txt

echo Done
