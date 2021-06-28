#!/bin/sh

set -e

echo 'Creating lists...'
sdreport -c"" -nh actives.sdf | cut -f 2 -d "," > actives.txt

echo Filtering results ...
sdsort -n -s -f$2 $1 | sdfilter -f'$_COUNT == 1' -s_TITLE1 > results_1poseperlig.sdf

echo Preparing data for R ...
sdreport -t$2 results_1poseperlig.sdf | awk '{print $2,$3}' > dataforR_uq.txt

echo Done

